class User < ActiveRecord::Base
  include RoleModel
  include PgSearch
  roles *[
    :admin, :firefighter, :reporter,
    :bosses, :officer, :subofficer, :radio,
    :sysadmin, :shifts_admin, :intervention_admin
  ]

  has_paper_trail

  pg_search_scope :unicode_search,
    against: [:name, :lastname, :email],
    ignoring: :accents,
    using: {
      tsearch: { prefix: false },
      trigram: { threshold: 0.1 }
    }


  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Defaul order
  default_scope -> () { order('lastname ASC') }

  # Validations
  validates :name, presence: true
  validates :name, :lastname, :email, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  has_one :firefighter
  has_many :interventions, foreign_key: 'receptor_id'
  has_many :shifts, through: :firefighter

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.role ||= :firefighter
  end

  def to_s
    [self.name, self.lastname].compact.join(' ')
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label]
    }

    super(default_options.merge(options || {}))
  end

  def role
    self.roles.first.try(:to_sym)
  end

  def role=(role)
    self.roles = [role]
  end

  def self.filtered_list(query)
    query.present? ? unicode_search(query) : all
  end

  def self.default_receptor
    console = find_by(email: 'console@firehouse.com')
    console.present? ? console : (raise 'Need console user')
  end
end
