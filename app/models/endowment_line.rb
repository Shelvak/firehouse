class EndowmentLine < ApplicationModel
  default_scope -> { order(charge: :asc) }

  CHARGES = {
    1 => 'head',
    2 => 'pitonero',
    3 => 'firefighters',
    4 => 'radio',
    5 => 'driver',
    6 => 'backup'
  }.with_indifferent_access.freeze

  #attr_accessible :charge, :firefighters_names

  attr_accessor :firefighters_names

  belongs_to :endowments
  has_many :endowment_line_firefighter_relations
  has_many :firefighters, through: :endowment_line_firefighter_relations,
    autosave: true

  validates :charge, presence: true

  # def initialize(attributes = nil, options = {})
  #   super(attributes, options)
  # end

  def firefighters_names=(ids)
    f_ids = ids.is_a?(Array) ? ids : ids.to_s.split(',')

    self.firefighter_ids = f_ids.uniq.compact.reject(&:blank?)
  rescue PG::UniqueViolation
    true
  end

  def firefighters_names
    self.firefighters.map(&:to_s).join(', ')
  end
end
