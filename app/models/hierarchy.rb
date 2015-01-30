class Hierarchy < ActiveRecord::Base
  has_paper_trail
  has_magick_columns name: :string

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
    query.present? ? magick_search(query) : all
  end
end
