class Endowment < ActiveRecord::Base
  has_paper_trail

  attr_accessible :number

  belongs_to :intervention
  has_many :endowment_lines

  validates :number, presence: true
end
