class Truck < ActiveRecord::Base
  has_paper_trail
  has_magick_columns number: :integer

  attr_accessible :number, :mileage

  validates :number, presence: true
  validates :number, uniqueness: true

  has_many :endowments

  def to_s
    self.number
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label, :mileage]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : scoped
  end
end
