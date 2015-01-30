class Person < ActiveRecord::Base
  has_paper_trail

  belongs_to :building
  belongs_to :vehicle

  #attr_accessible :name, :last_name, :address, :dni_type, :dni_number, :age,
  #  :phone_number, :relation, :moved_to, :injuries, :building_id, :vehicle_id

  validates :name, presence: true
end
