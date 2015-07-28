class Intervention < ActiveRecord::Base
  has_paper_trail
  has_magick_columns address: :string, id: :integer

  attr_accessor :auto_receptor_name, :auto_sco_name

 # attr_accessible :address, :kind_notes, :near_corner, :number,
 #   :observations, :receptor_id, :endowments_attributes, :auto_sco_name,
 #   :sco_id, :informer_attributes, :auto_receptor_name, :intervention_type_id,
 #   :latitude, :longitude, :endowments

  validates :intervention_type_id, presence: true
  #validates :number, uniqueness: true
  #validate :sco_presence

  before_validation :assign_endowment_number, :validate_truck_presence
  after_create :assign_mileage_to_trucks, :send_first_alert_to_redis,
    :play_intervention_audio!
  after_save :endowment_alert_changer, :put_in_redis_list

  belongs_to :intervention_type
  belongs_to :user, foreign_key: 'receptor_id'
  belongs_to :sco
  has_one :informer
  has_one :mobile_intervention
  has_many :alerts
  has_many :endowments
  has_many :statuses, as: :trackeable

  scope :opened, -> { includes(:statuses).where(statuses: { name: 'open' }) }

  accepts_nested_attributes_for :informer, allow_destroy: true,
    reject_if: ->(attrs) { attrs['full_name'].blank? && attrs['nid'].blank? }
  accepts_nested_attributes_for :endowments, allow_destroy: true,
    reject_if: :reject_endowment_item?

  delegate :audio, to: :intervention_type

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.endowments.build if self.endowments.empty?
  end

  def receptor
    self.user
  end

  def reject_endowment_item?(attrs)
    endow_reject = false

    attrs['endowment_lines_attributes'].each do |i, e|
      endow_reject ||= e['firefighters_names'].present?
    end

    attrs['truck_id'].blank? && attrs['truck_number'].blank? && !endow_reject
  end

  def sco_presence
    if self.sco_id.blank? && self.informer.blank?
      self.errors.add :auto_sco_name, :blank
    end
  end

  def assign_endowment_number
    self.endowments.each_with_index { |e, i| e.number ||= i + 1}
  end

  def assign_mileage_to_trucks
    self.endowments.each do |e|
      e.truck.update_attributes(mileage: e.in_mileage) if e.in_mileage
    end
  end

  def type
    self.intervention_type.try(:name)
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
    end
  end

  def reactivate!
    alerts.create!

    send_lights
  end

  def its_a_trap!
    _lights = lights_for_redis
    _lights['trap'] = true

    save_lights_on_redis(_lights)
    send_lights
  end

  def save_lights_on_redis(_lights)
    $redis.set('interventions:' + self.id.to_s, _lights.to_json)
  end

  def default_lights
    _lights = intervention_type.lights
    _lights['day'] = (8..19).include?(Time.now.hour)
    _lights
  end

  def lights_for_redis
    if (_lights = $redis.get('interventions:' + self.id.to_s)).present?
      JSON.parse _lights
    else
      _lights = default_lights
      save_lights_on_redis(_lights)
      _lights
    end
  end

  def send_lights
    stop_running_alerts!

    $redis.publish('semaphore-lights-alert', lights_for_redis.to_json)
  end

  def turn_off_the_lights!
    off = InterventionType::COLORS.inject({}) {|h, light| h.merge!(light => false)}
    $redis.publish('semaphore-lights-alert', off.to_json)
  end

  def send_first_alert_to_redis
    put_in_redis_list

    send_lights
  end

  def is_active?
    $redis.lrange('interventions:actives', 0, -1).include? self.id
  end

  def endowment_alert_changer
    case
      when endowments.any? { |e| e.out_at.present? } then send_alert_on_repose
      when endowments.any? { |e| e.in_at.present? }  then turn_off_alert
    end
  end

  def send_alert_on_repose
    _lights = lights_for_redis
    _lights['sleep'] = true

    save_lights_on_redis(_lights)
    start_looping_active_alerts!
  end

  def turn_off_alert
    remove_item_from_actives_list
    $redis.del('interventions:' + self.id.to_s)
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

    unless is_on_list?(list)
      remove_item_from_actives_list

      $redis.lpush(list, self.id)
    end
  end

  def is_on_list?(list)
    $redis.lrange(list, 0, -1).include?(self.id)
  end

  def remove_item_from_list(list)
    $redis.lrem(list, 1, self.id)
  end

  def remove_item_from_actives_list
    ['low', 'high'].each do |priority|
      kind = intervention_type.emergency_or_urgency
      list = "interventions:#{priority}:#{kind}"

      remove_item_from_list(list)
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
    endowments.map{ |endowment| endowment.truck.number if endowment.truck }.uniq
  end
end
