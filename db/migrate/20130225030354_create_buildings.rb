class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :address
      t.text :description
      t.string :floor
      t.string :roof
      t.string :window
      t.string :electrics
      t.text :damage
      t.integer :mobile_intervention_id

      t.timestamps
    end
  end
end
