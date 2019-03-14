class Endowment < ActiveRecord::Base
  has_paper_trail

  attr_accessor :truck_number

  #attr_accessible :number, :endowment_lines_attributes, :out_at,
  #  :arrive_at, :back_at, :in_at, :out_mileage, :arrive_mileage, :back_mileage,
  #  :in_mileage, :truck_number, :truck_id, :intervention_id

  belongs_to :intervention, touch: true
  belongs_to :truck
  has_many :endowment_lines
  has_one :mobile_intervention

  validates :number, numericality: { only_integer: true, greater_than: 0 }
  validate :truck_out_in_distance

  before_validation :assign_truck

  validates_each :number, if: :new_record? do |endowment, attr, value|
    if endowment.intervention
      used_numbers = endowment.intervention.endowments.reject(&:new_record?).map do |e|
        e.number.to_i
      end

      endowment.errors.add(:number, :taken) if used_numbers.include?(value.to_i)
    end
  end

  accepts_nested_attributes_for :endowment_lines, allow_destroy: true

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.number ||= 1

    EndowmentLine::CHARGES.each do |k, v|
      self.endowment_lines.build(charge: k)
    end if self.endowment_lines.empty?
  end

  def assign_truck
    if truck_number && truck_id.blank?
      self.truck_id = Truck.where(number: self.truck_number).first.try(:id)
      self.out_mileage = self.truck.try(:mileage) if out_mileage.blank?
    end
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
end
