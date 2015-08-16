class User < ActiveRecord::Base
  include RoleModel

  roles :admin, :regular

  has_paper_trail

  has_magick_columns name: :string, lastname: :string, email: :email

  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  attr_accessor :auto_hierarchy_name

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :name, :lastname, :email, :password, :password_confirmation,
  #  :role, :remember_me, :lock_version, :auto_hierarchy_name, :hierarchy_id

  # Defaul order
  default_scope -> () { order('lastname ASC') }

  # Validations
  validates :name, presence: true
  validates :name, :lastname, :email, length: { maximum: 255 }, allow_nil: true,
    allow_blank: true

  # Relations
  has_many :interventions, foreign_key: 'receptor_id'
  belongs_to :hierarchy
  has_one :user

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.role ||= :regular
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
    query.present? ? magick_search(query) : all
  end

  def self.default_receptor
    console = find_by(email: 'console@firehouse.com')
    console.present? ? console : (raise 'Need console user')
  end
end
