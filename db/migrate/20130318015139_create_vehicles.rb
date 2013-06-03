class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :mark
      t.string :model
      t.string :year
      t.string :domain
      t.text :damage
      t.integer :mobile_intervention_id

      t.timestamps
    end
  end
end
