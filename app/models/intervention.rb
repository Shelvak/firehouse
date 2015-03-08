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
  after_create :assign_mileage_to_trucks, :send_alert_to_redis

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

  def special_sign(sign)
    case sign
      when 'alert' then reactivate!
      when 'trap'  then its_a_trap!
    end
  end

  def reactivate!
    alerts.create!

    send_lights
  end

  def is_trap?
    $redis.lrange('interventions:traps', 0, -1).include? self.id
  end

  def its_a_trap!
    $redis.lpush('interventions:traps', self.id) unless is_trap?

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
    if (_lights = $redis.get('interventions:' + self.id.to_s))
      JSON.parse _lights
    else
      _lights = default_lights
      save_lights_on_redis(_lights)
      _lights
    end
  end

  def send_lights
    $redis.publish('semaphore-lights-alert', lights_for_redis.to_json)
  end

  def send_alert_to_redis
    $redis.lpush('interventions:actives', self.id)

    send_lights
  end

  def is_active?
    $redis.lrange('interventions:actives', 0, -1).include? self.id
  end
end
