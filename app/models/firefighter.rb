class Firefighter < ActiveRecord::Base
  has_paper_trail
  has_magick_columns identification: :integer, firstname: :string,
    lastname: :string

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

  #attr_accessible :firstname, :lastname, :identification
  attr_accessor :auto_user_name

  belongs_to :user

  has_many :endowment_line_firefighter_relations
  has_many :endowment_lines, through: :endowment_line_firefighter_relations,
   autosave: true
  has_many :relatives

  # todo: validaciones de tipos
  validates :firstname, :lastname, :identification, presence: true
  validates :identification, uniqueness: true
  validates :user_id, uniqueness: true, allow_nil: true, allow_blank: true

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
    query.present? ? magick_search(query) : all
  end
end
