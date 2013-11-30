class CreateEndowmentLinesFirefighters < ActiveRecord::Migration
  def change
    create_table :endowment_line_firefighter_relations do |t|
      t.integer :endowment_line_id, null: false
      t.integer :firefighter_id, null: false

      t.timestamps
    end

    add_index :endowment_line_firefighter_relations, 
      [:endowment_line_id, :firefighter_id], 
      unique: true, name: 'endowment_line_id_firefighter_id_relation_index'
  end
end
