class Intervention < ActiveRecord::Base
  has_paper_trail
  has_magick_columns address: :string, number: :integer

  attr_accessor :auto_receptor_name, :auto_sco_name
  
  attr_accessible :address, :kind_notes, :near_corner, :number,
    :observations, :receptor_id, :endowments_attributes, :auto_sco_name,
    :sco_id, :informer_attributes, :auto_receptor_name, :intervention_type_id,
    :latitude, :longitude

  validates :address, :intervention_type_id, :number, :receptor_id, presence: true
  validates :number, uniqueness: true
  validate :sco_presence

  before_validation :assign_intervention_number, :assign_endowment_number
  after_create :assign_mileage_to_trucks

  belongs_to :intervention_type
  belongs_to :user, foreign_key: 'receptor_id'
  belongs_to :sco
  has_one :informer
  has_one :mobile_intervention
  has_many :endowments

  accepts_nested_attributes_for :informer, allow_destroy: true,
    reject_if: ->(attrs) { attrs['full_name'].blank? && attrs['nid'].blank? }
  accepts_nested_attributes_for :endowments, allow_destroy: true,
    reject_if: :reject_endowment_item?

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    #self.endowments.build if self.endowments.empty? Mommentary disabled
  end

  def receptor
    self.user
  end

  def reject_endowment_item?(attrs)
    attrs['truck_id'].blank? && attrs['truck_number'].blank?
  end
 
  def sco_presence
    if self.sco_id.blank? && self.informer.blank?
      self.errors.add :auto_sco_name, :blank 
    end
  end
  
  def assign_intervention_number
    # with this sure that present and unique always work =)
    self.number = (Intervention.order(:number).last.try(:number) || 0) + 1
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
    self.intervention_type.name
  end
end
