class Informer < ActiveRecord::Base
  has_paper_trail

  attr_accessible :full_name, :nid, :phone, :address, :intervention_id

  validates :full_name, :nid, presence: true

  belongs_to :intervention
end
