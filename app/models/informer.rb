class Informer < ActiveRecord::Base
  has_paper_trail

  #attr_accessible :full_name, :nid, :phone, :address, :intervention_id

  belongs_to :intervention

  validates :phone, numericality: {
    only_integer: true, allow_nil: true, allow_blank: true
  }
  validates :full_name, presence: true
end
