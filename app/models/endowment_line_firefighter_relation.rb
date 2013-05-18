class EndowmentLineFirefighterRelation < ActiveRecord::Base
  has_paper_trail

  belongs_to :endowment_line
  belongs_to :firefighter
end
