class Sco < ActiveRecord::Base
  include PgSearch
  has_paper_trail

  pg_search_scope :unicode_search,
    against: [:full_name],
    ignoring: :accents,
    using: {
      tsearch: { prefix: false },
      trigram: { threshold: 0.1 }
    }


  #attr_accessible :full_name, :current

  validates :full_name, presence: true

  has_many :interventions

  def to_s
    self.full_name
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

  def activate!
    keep_only_one_current
    Sco.current.try(:desactivate!) if Sco.current
    self.update_attributes!(current: true)
  end

  def desactivate!
    self.update_attributes!(current: false)
  end

  def keep_only_one_current
    if Sco.where(current: true).count > 1
      Sco.where(current: true).order('updated_at DESC').each_with_index do |sco, i|
        sco.desactivate! if i != 0
      end
    end
  end

  def self.current
    where(current: true).first
  end
end
