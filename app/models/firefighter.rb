class Firefighter < ActiveRecord::Base
  include PgSearch
  has_paper_trail
  pg_search_scope :unicode_search,
    against: [:identification, :firstname, :lastname],
    ignoring: :accents,
    using: {
      tsearch: { prefix: false },
      trigram: { threshold: 0.1 }
    }

  STATES = [
      'Ciudad Autonoma de Buenos Aires', 'Provincia de Buenos Aires',
      'Catamarca', 'Córdoba', 'Corrientes', 'Entre Ríos', 'Jujuy', 'Mendoza',
      'La Rioja', 'Salta', 'San Juan', 'San Luis', 'Santa Fe', 'Santiago del Estero',
      'Tucumán', 'Chaco', 'Chubut', 'Formosa', 'Misiones', 'Neuquén', 'La Pampa',
      'Río Negro', 'Santa Cruz', 'Tierra del Fuego'
  ]

  EDUCATION_LEVELS = [
    I18n.t('view.firefighters.education_levels.none'),
    I18n.t('view.firefighters.education_levels.elemental'),
    I18n.t('view.firefighters.education_levels.highschool'),
    I18n.t('view.firefighters.education_levels.third_grade'),
    I18n.t('view.firefighters.education_levels.college'),
    I18n.t('view.firefighters.education_levels.master')
  ]

  attr_accessor :auto_user_name, :auto_hierarchy_name

  belongs_to :user
  belongs_to :hierarchy

  has_many :endowment_line_firefighter_relations
  has_many :endowment_lines, through: :endowment_line_firefighter_relations,
   autosave: true
  has_many :relatives
  has_many :shifts
  has_many :dockets

  # todo: validaciones de tipos
  validates :firstname, :lastname, :identification, presence: true
  validates :identification, uniqueness: true
  validates :user_id, uniqueness: true, allow_nil: true, allow_blank: true
  validate :hierarchy_presence, if: -> { self.auto_hierarchy_name.present? }

  def to_s
    [self.lastname, self.firstname].join(' ')
  end

  alias_method :label, :to_s

  def blood
    [blood_type, blood_factor].join(' ')
  end

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? unicode_search(query) : all
  end

  def hierarchy_presence
    self.errors.add(
      :auto_hierarchy_name,
      I18n.t(
        'validations.autocomplete.must_pick_one',
        attr: self.class.human_attribute_name('hierarchy_id').downcase
      )
    ) if self.hierarchy_id.blank?
  end
end
