class MobileIntervention < ActiveRecord::Base
  has_paper_trail

  belongs_to :intervention
  has_many :buildings

  attr_accessible :date, :emergency, :observations, :intervention_id

end
