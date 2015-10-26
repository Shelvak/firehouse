class Insurance < ActiveRecord::Base
  has_paper_trail

  #attr_accessible :policy_number, :company, :valid_until, :building_id, :person_id

  belongs_to :building
  belongs_to :person

end
