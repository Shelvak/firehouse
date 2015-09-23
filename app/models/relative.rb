class Relative < ActiveRecord::Base
  has_paper_trail

  RELATIVE_TYPES = [
      I18n.t('view.relatives.types.mother'),
      I18n.t('view.relatives.types.father'),
      I18n.t('view.relatives.types.married'),
      I18n.t('view.relatives.types.son'),
      I18n.t('view.relatives.types.brothers'),
      I18n.t('view.relatives.types.other')
  ]

  belongs_to :firefighter

  validates :firefighter_id, presence: true

  def to_s
    "#{name} #{last_name}"
  end
end
