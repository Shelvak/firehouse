class CreateInterventionTypes < ActiveRecord::Migration
  def change
    create_table :intervention_types do |t|
      t.string :name
      t.integer :priority
      t.integer :intervention_type_id
      t.string :image
      t.string :color
      t.string :target
      t.string :callback

      t.timestamps
    end
  end
end
