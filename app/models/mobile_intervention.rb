class MobileIntervention < ActiveRecord::Base
  has_paper_trail

  belongs_to :intervention

  attr_accessible :date, :emergency, :observations, :intervention_id

end
