class CreateInterventions < ActiveRecord::Migration
  def change
    create_table :interventions do |t|
      t.string :address
      t.string :near_corner
      t.string :kind, limit: 1, null: false
      t.string :kind_notes
      t.integer :receptor_id, null: false
      t.integer :hierarchy_id
      t.text :observations

      t.timestamps
    end

    add_index :interventions, :receptor_id
    add_index :interventions, :kind
  end
end
