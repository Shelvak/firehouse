class EndowmentLine < ActiveRecord::Base
  has_paper_trail

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

  def initialize(attributes = nil, options = {})
    super(attributes, options)
  end

  def firefighters_names=(ids)
    self.firefighter_ids = ids.split(',')
  end

  def firefighters_names
    self.firefighters.map(&:to_s).join(', ')
  end
end
