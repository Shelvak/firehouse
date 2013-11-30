class Firefighter < ActiveRecord::Base
  has_paper_trail
  has_magick_columns identification: :integer, firstname: :string, 
    lastname: :string

  attr_accessible :firstname, :lastname, :identification

  has_many :endowment_line_firefighter_relations
  has_many :endowment_lines, through: :endowment_line_firefighter_relations,
   autosave: true

  validates :firstname, :lastname, :identification, presence: true
  validates :identification, uniqueness: true

  def to_s
    [self.lastname, self.firstname].join(' ')
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
