class Intervention < ActiveRecord::Base
  has_paper_trail
  has_magick_columns address: :string, id: :integer

  attr_accessor :auto_receptor_name, :auto_sco_name

  validates :intervention_type_id, presence: true

  before_validation :assign_endowment_number, :validate_truck_presence
  after_create :send_first_alert!, :play_intervention_audio!,
    if: -> (i) { i.intervention_type.emergency? }
  after_save :endowment_alert_changer, :assign_mileage_to_trucks

  belongs_to :intervention_type
  belongs_to :user, foreign_key: 'receptor_id'
  belongs_to :sco
  has_one :informer
  has_one :mobile_intervention
  has_many :alerts
  has_many :endowments
  has_many :statuses, as: :trackeable

  scope :opened, -> { includes(:statuses).where(statuses: { name: 'open' }) }

  accepts_nested_attributes_for :informer,
    reject_if: ->(attrs) { attrs['full_name'].blank? && attrs['nid'].blank? }
  accepts_nested_attributes_for :endowments, allow_destroy: true,
    reject_if: :reject_endowment_item?

  delegate :audio, to: :intervention_type

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.endowments.build if self.endowments.empty?
  end

  def self.create_by_lights(lights)
    if (it = InterventionType.find_by_lights(lights)).present?
      intervention = create(
        intervention_type_id: it.id, receptor_id: User.default_receptor.id
      )
      $redis.publish(
        'socketio-new-intervention',
        url_helpers.edit_intervention_path(intervention)
      )
    end
  end

  def to_s
    _to_s = "##{self.id} - #{self.type}"
    _to_s << " (#{I18n.t('view.interventions.kinds.its_a_trap')})" if its_a_trap?
    _to_s
  end

  def self.url_helpers
    Rails.application.routes.url_helpers
  end

  def receptor
    self.user
  end

  def reject_endowment_item?(attrs)
    endow_reject = attrs['endowment_lines_attributes'].any? do |_, e|
      e['firefighters_names'].present?
    end

    attrs['truck_id'].blank? && attrs['truck_number'].blank? && !endow_reject
  end

  def sco_presence
    if self.sco_id.blank? && self.informer.blank?
      self.errors.add :auto_sco_name, :blank
    end
  end

  def assign_endowment_number
    self.endowments.each_with_index { |e, i| e.number ||= i + 1 }
  end

  def assign_mileage_to_trucks
    self.endowments.each do |e|
      e.truck.update_attributes(mileage: e.in_mileage) if e.in_mileage
    end
  end

  def type
    self.intervention_type.try(:to_s)
  end

  def validate_truck_presence
    self.endowments.each do |e|
      if e.truck_id.blank? || e.truck_number.blank?
        e.errors.add :truck_number, :blank
      end
    end
  end

  def formatted_description
    "#{type}: #{address}"
  end

  def popup_description(index = nil)
    base_i18n_key = 'view.interventions.map.marker_popup'
    popup_params  = { type: type, address: address }
    popup_type    = '.common'

    if index
      index               += 1
      popup_params[:index] = index
      popup_type           = '.with_index'

      if trucks_numbers.any?
        popup_type            = '.with_truck'
        popup_params[:trucks] = trucks_numbers
      end
    end

    I18n.t(base_i18n_key + popup_type, popup_params)
  end

  def special_sign(sign)
    case sign.to_s
      when 'alert' then reactivate!
      when 'trap'  then its_a_trap!
      when 'qta'   then turn_off_alert
    end
  end

  def reactivate!
    intervention_type.emergency? ? send_lights : send_first_alert!

    play_intervention_audio!
  end

  def its_a_trap!
    lights = lights_for_redis
    lights['trap'] = true

    update_column(:its_a_trap, true)

    save_lights_on_redis(lights)
    send_lights
  end

  def save_lights_on_redis(lights)
    $redis.set('interventions:' + self.id.to_s, lights.to_json)
  end

  def default_lights
    lights = intervention_type.lights
    lights['day'] = (8..19).include?(Time.zone.now.hour)
    lights
  end

  def lights_for_redis
    if (lights = $redis.get('interventions:' + self.id.to_s)).present?
      JSON.parse lights
    else
      lights = default_lights
      save_lights_on_redis(lights)
      lights
    end
  end

  def send_lights
    stop_running_alerts!

    $redis.publish('semaphore-lights-alert', lights_for_redis.to_json)
  end

  def turn_off_the_lights!
    $redis.publish(
      'semaphore-lights-alert',
      InterventionType::COLORS_LIGHTS_OFF.to_json
    )
  end

  def send_first_alert!
    alerts.create!
    send_alert_to_lcd
    put_in_redis_list

    send_lights
  end

  def send_alert_to_lcd
    $redis.publish('lcd-messages', { full: self.to_s }.to_json)
  end

  def active?
    $redis.lrange('interventions:actives', 0, -1).include? self.id
  end

  def endowment_alert_changer
    case
      when endowments.any? { |e| e.in_at.present? }  then turn_off_alert
      when endowments.any? { |e| e.out_at.present? } then send_alert_on_repose
    end
  end

  def send_alert_on_repose
    lights = lights_for_redis
    lights['sleep'] = true

    save_lights_on_redis(lights)
    put_in_redis_list
    start_looping_active_alerts!
  end

  def turn_off_alert
    remove_item_from_actives_list
    $redis.del('interventions:' + self.id.to_s)
    $redis.publish('stop-broadcast', 'stop')
    turn_off_the_lights!
  end

  def start_looping_active_alerts!
    $redis.publish('interventions:lights:start_loop', 'start')
  end

  def stop_running_alerts!
    $redis.publish('interventions:lights:stop_loop', 'stop')
  end

  def lights_off
    InterventionType::COLORS.inject({}) { |h, c| h.merge!(c => false) }
  end

  def endowment_out?
    endowments.any? { |e| e.out_at.present? }
  end

  def list_key_for_redis
    priority = endowment_out? ? 'low' : 'high'
    kind     = intervention_type.emergency_or_urgency

    "interventions:#{priority}:#{kind}"
  end

  def put_in_redis_list
    list = list_key_for_redis

    if not_in_list?(list)
      remove_item_from_actives_list

      $redis.lpush(list, self.id)
    end
  end

  def not_in_list?(list)
    !in_list?(list)
  end

  def in_list?(list)
    $redis.lrange(list, 0, -1).include?(self.id)
  end

  def remove_item_from_list(list)
    $redis.lrem(list, 1, self.id)
  end

  def remove_item_from_actives_list
    kind = intervention_type.emergency_or_urgency

    %w(low high).each do |priority|
      remove_item_from_list("interventions:#{priority}:#{kind}")
    end
  end

  def finished?
    self.endowments.all? { |e| e.in_at.present? }
  end

  def play_intervention_audio!
    if self.audio.try(:file)
      $redis.publish('interventions:play_audio_file', self.audio.url)
    end
  end

protected

  def trucks_numbers
    endowments.map { |endowment| endowment.truck.number if endowment.truck }.uniq
  end
end
