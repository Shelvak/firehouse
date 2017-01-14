class Shift < ActiveRecord::Base
  has_paper_trail

  KINDS = {
    0 => 'volunteer_guard',
    1 => 'mandatory_guard',
    2 => 'internal_training',
    3 => 'external_training',
    4 => 'others'
  }

  scope :between, ->(start, finish) { where(created_at: start..finish) }
  scope :finished, ->() { where.not(finish_at: nil) }

  belongs_to :firefighter

  validates :firefighter, :start_at, :kind, presence: true
  validates_datetime :start_at, allow_nil: true, allow_blank: true
  validates_datetime :start_at, before: :finish_at,
    allow_nil: true, allow_blank: true, if: :finish_at_present?
  validates_datetime :finish_at, after: :start_at, allow_nil: true, allow_blank: true

  def to_s
    self.firefighter
  end

  def finish_at_present?
    self.finish_at.present?
  end

  def self.reports_between(start, finish)
    _scope = finished.between(start, finish)
    firefighter_ids = _scope.pluck(:firefighter_id).uniq.compact.sort

    reports = []
    firefighter_ids.each do |firefighter_id|
      firefighter_name = nil
      kinds = {}
      total_seconds = 0

      _scope.where(firefighter_id: firefighter_id).group_by(&:kind).each do |kind, shifts|
        firefighter_name ||= shifts.first.firefighter.to_s
        kinds[kind] = (shifts.to_a.sum { |s| s.finish_at - s.start_at }).round.to_i
        total_seconds += kinds[kind]
      end

      reports << OpenStruct.new({
        firefighter: firefighter_name,
        kinds: kinds,
        total_seconds: total_seconds
      })
    end

    reports
  end
end
