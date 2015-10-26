class Person < ActiveRecord::Base
  has_paper_trail

  belongs_to :building
  belongs_to :vehicle

  #attr_accessible :name, :last_name, :address, :dni_type, :dni_number, :age,
  #  :phone_number, :relation, :moved_to, :injuries, :building_id, :vehicle_id

  validates :name, :last_name, :dni_type, :dni_number, :genre, presence: true

  GENERES_FOR_COLLECTION = [
      I18n.t('view.people.collections.genre.male'),
      I18n.t('view.people.collections.genre.female'),
      I18n.t('view.people.collections.genre.other'),
      I18n.t('view.people.collections.genre.unknown')
  ]
end
