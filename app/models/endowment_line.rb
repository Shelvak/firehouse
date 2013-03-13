class EndowmentLine < ActiveRecord::Base
  has_paper_trail

  CHARGES = {
    1 => 'head',
    2 => 'pitonero',
    3 => 'firefighters',
    4 => 'radio',
    5 => 'driver',
    6 => 'backup'
  }.with_indifferent_access.freeze

  attr_accessible :firefighter_id, :charge, :auto_firefighter_name

  attr_accessor :auto_firefighter_name

  belongs_to :endowments
  belongs_to :firefighter

  validates :firefighter_id, :charge, presence: true

  def initialize(attributes = nil, options = {})
    super(attributes, options)
  end
end
