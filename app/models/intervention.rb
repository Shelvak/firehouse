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
  
  attr_accessible :address, :kind, :kind_notes, :near_corner, 
    :number, :observations, :receptor_id, :truck_id, :out_at, :arrive_at, 
    :back_at, :in_at, :out_mileage, :arrive_mileage, :back_mileage, :in_mileage

  validates :address, :kind, :number, :receptor_id, presence: true
  validates :number, uniqueness: true
  validate :truck_out_in_time
  validate :truck_out_in_distance

  belongs_to :user, foreign_key: 'receptor_id'
  belongs_to :truck
  has_many :informers

  accepts_nested_attributes_for :informers, allow_destroy: false,
    reject_if: ->(attrs) { attrs['full_name'].blank? && attrs['nid'].blank? }

  def truck_out_in_time
    validate_errors_between_two_datetimes(self.out_at, self.arrive_at, :arrive_at)
    validate_errors_between_two_datetimes(self.out_at, self.back_at, :back_at)
    validate_errors_between_two_datetimes(self.out_at, self.in_at, :in_at)
    validate_errors_between_two_datetimes(self.arrive_at, self.back_at, :back_at)
    validate_errors_between_two_datetimes(self.arrive_at, self.in_at, :in_at)
    validate_errors_between_two_datetimes(self.back_at, self.in_at, :in_at)
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

  def validate_errors_between_two_datetimes(first, second, second_sym)
    if first && second && first > second
      self.errors.add second_sym, I18n.t(
        'validations.date.must_be_after', date: I18n.l(first, format: :minimal)
      )
    end
  end

  def validate_errors_between_two_distances(first, second, second_sym)
    if first && second && first > second
      self.errors.add second_sym, I18n.t(
        'validations.distance.must_be_greater_than', distance: first
      )
   
    end
  end

  def reject_informers_attributes(attrs)
    
  end
end
