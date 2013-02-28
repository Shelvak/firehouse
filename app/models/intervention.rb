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

  attr_accessor :auto_truck_number, :auto_receptor_name
  
  attr_accessible :address, :kind, :kind_notes, :near_corner, 
    :number, :observations, :receptor_id, :truck_id, :out_at, :arrive_at, 
    :back_at, :in_at, :out_mileage, :arrive_mileage, :back_mileage, :in_mileage,
    :sco_id, :informer_attributes, :auto_truck_number, :auto_receptor_name 

  validates :address, :kind, :number, :receptor_id, presence: true
  validates :number, uniqueness: true
  validate :truck_out_in_distance

  before_save :assign_intervention_number

  belongs_to :user, foreign_key: 'receptor_id'
  belongs_to :truck
  belongs_to :sco
  has_one :informer

  accepts_nested_attributes_for :informer, allow_destroy: true,
    reject_if: ->(attrs) { attrs['full_name'].blank? && attrs['nid'].blank? }

  def initialize(attributes = nil, options = {})
    super(attributes, options)
  end

  def receptor
    self.user
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
    self.number = (Intervention.order(:number).last.try(:number) || 0) + 1
  end
end
