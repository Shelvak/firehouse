class Person < ActiveRecord::Base
  has_paper_trail


  belongs_to :building

  attr_accessible :name, :last_name, :address, :dni_type, :dni_number, :age, :phone_number, :relation, :moved_to, :injuries, :building_id

end
