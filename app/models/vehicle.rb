class Vehicle < ActiveRecord::Base
  has_paper_trail

  belongs_to :mobile_intervention
  has_many :people
  has_one :insurance

  #attr_accessible :mark, :model, :year, :domain, :damage,
  #  :mobile_intervention_id

  validates :damage, :domain, presence: true

end
