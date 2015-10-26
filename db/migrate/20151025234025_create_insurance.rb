class CreateInsurance < ActiveRecord::Migration
  def change
    create_table :insurances do |t|
      t.string :policy_number
      t.string :company
      t.date :valid_until
      t.integer :building_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
