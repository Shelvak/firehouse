class Endowment < ActiveRecord::Base
  has_paper_trail

  attr_accessible :number, :endowment_lines_attributes

  belongs_to :intervention
  has_many :endowment_lines

  validates :number, presence: true
  accepts_nested_attributes_for :endowment_lines, allow_destroy: true

  def initialize(attributes = nil, options = {})
    super(attributes, options)
  
    EndowmentLine::CHARGES.each do |k, v|
      self.endowment_lines.build(charge: k)
    end if self.endowment_lines.empty?
  end
end
