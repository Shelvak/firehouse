class Shift < ActiveRecord::Base
  KINDS = [
    'voluntary',
    'mandatory',
    'others'
  ]

  has_paper_trail

  belongs_to :firefighter

  validates :start_at, :kind, presence: true

  def to_s
    self.firefighter
  end
end
