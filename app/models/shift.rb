class Shift < ActiveRecord::Base
  KINDS = [
    'volunteer_guard',
    'mandatory_guard',
    'internal_training',
    'external_training',
    'others'
  ]

  has_paper_trail

  belongs_to :firefighter

  validates :firefighter, :start_at, :kind, presence: true
  validates_datetime :start_at, allow_nil: true, allow_blank: true
  validates_datetime :start_at, before: :finish,
    allow_nil: true, allow_blank: true, if: :finish_at_present?
  validates_datetime :finish_at, after: :start_at, allow_nil: true, allow_blank: true

  def to_s
    self.firefighter
  end

  def finish_at_present?
    self.finish_at.present?
  end
end
