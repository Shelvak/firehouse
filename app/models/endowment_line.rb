class EndowmentLine < ActiveRecord::Base
  has_paper_trail

  attr_accessible :firefighter_id, :charge, :endowment_id

  belongs_to :endowments
  belongs_to :firefighter

  validates :firefighter_id, :charge, presence: true
end
