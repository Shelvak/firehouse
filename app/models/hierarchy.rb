class Hierarchy < ActiveRecord::Base
  include PgSearch
  has_paper_trail
  pg_search_scope :unicode_search,
    against: [:name],
    ignoring: :accents,
    using: {
      tsearch: { prefix: false },
      trigram: { threshold: 0.1 }
    }


  #attr_accessible :name

  validates :name, presence: true

  has_many :users

  def to_s
    self.name
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
    query.present? ? unicode_search(query) : all
  end
end
