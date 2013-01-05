class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.integer :number
      t.integer :mileage

      t.timestamps
    end

    add_index :trucks, :number, unique: true
  end
end
