class MobileIntervention < ActiveRecord::Base
  has_paper_trail

  belongs_to :endowment
  has_many :buildings
  has_many :supports
  has_many :vehicles

  attr_accessible :date, :emergency, :observations, :endowment_id

end
