class Informer < ActiveRecord::Base
  has_paper_trail

  attr_accessible :full_name, :nid, :phone, :address, :intervention_id

  belongs_to :intervention
end
