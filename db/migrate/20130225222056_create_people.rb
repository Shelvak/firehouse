class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :last_name
      t.string :address
      t.string :dni_type
      t.string :dni_number
      t.integer :age
      t.string :phone_number
      t.string :relation
      t.string :moved_to
      t.text :injuries
      t.integer :building_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
