class Intervention < ActiveRecord::Base
  has_paper_trail
  has_magick_columns address: :string, kind: :string, number: :integer

  KINDS = {
    car_accident: 'a',
    motorbike_accident: 'b',
    truck_accident: 'c',
    bus_accident: 'd',
    house_fire: 'e',
    car_fire: 'f',
    industry_fire: 'g',
    field_fire: 'h',
    animal_rescue: 'i',
    person_rescue: 'j',
    other: 'o'
  }.with_indifferent_access.freeze

  attr_accessor :auto_truck_number, :auto_receptor_name, :auto_sco_name
  
  attr_accessible :address, :kind, :kind_notes, :near_corner, 
    :number, :observations, :receptor_id, :truck_id, :out_at, :arrive_at, 
    :back_at, :in_at, :out_mileage, :arrive_mileage, :back_mileage, :in_mileage,
    :sco_id, :informer_attributes, :auto_truck_number, :auto_receptor_name,
    :endowments_attributes, :auto_sco_name

  validates :address, :kind, :number, :receptor_id, presence: true
  validates :number, uniqueness: true
  validate :truck_out_in_distance
  validate :truck_presence
  validate :sco_presence

  before_validation :assign_intervention_number, :assign_endowment_number

  belongs_to :user, foreign_key: 'receptor_id'
  belongs_to :truck
  belongs_to :sco
  has_one :informer
  has_one :mobile_intervention
  has_many :endowments

  accepts_nested_attributes_for :informer, allow_destroy: true,
    reject_if: ->(attrs) { attrs['full_name'].blank? && attrs['nid'].blank? }
  accepts_nested_attributes_for :endowments, allow_destroy: true

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.endowments.build if self.endowments.empty?
  end

  def receptor
    self.user
  end

  def truck_presence
    self.errors.add :auto_truck_number, :blank if self.truck_id.blank?
  end

  def sco_presence
    self.errors.add :auto_sco_name, :blank if self.sco_id.blank?
  end

  def truck_out_in_distance
    validate_errors_between_two_distances(
      self.out_mileage, self.arrive_mileage, :arrive_mileage
    )
    validate_errors_between_two_distances(
      self.out_mileage, self.back_mileage, :back_mileage
    )
    validate_errors_between_two_distances(
      self.out_mileage, self.in_mileage, :in_mileage
    )
    validate_errors_between_two_distances(
      self.arrive_mileage, self.back_mileage, :back_mileage
    )
    validate_errors_between_two_distances(
      self.arrive_mileage, self.in_mileage, :in_mileage
    )
    validate_errors_between_two_distances(
      self.back_mileage, self.in_mileage, :in_mileage
    )
  end

  def validate_errors_between_two_distances(first, second, second_sym)
    if first && second && first > second
      self.errors.add second_sym, I18n.t(
        'validations.distance.must_be_greater_than', distance: first
      )
   
    end
  end

  ['arrive', 'back', 'in'].each do |action|
    define_method("update_#{action}!") do
      self.update_attributes(
        "#{action}_at".to_sym => I18n.l(Time.now, format: :hour_min)
      )
    end
  end

  def assign_intervention_number
    # with this sure that present and unique always work =)
    self.number = (Intervention.order(:number).last.try(:number) || 0) + 1
  end

  def assign_endowment_number
    self.endowments.each_with_index { |e, i| e.number = i + 1}
  end
end
