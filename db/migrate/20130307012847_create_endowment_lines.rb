class CreateEndowmentLines < ActiveRecord::Migration
  def change
    create_table :endowment_lines do |t|
      t.integer :firefighter_id, null: false
      t.integer :charge, null: false
      t.integer :endowment_id, null: false

      t.timestamps
    end

    add_index :endowment_lines, :firefighter_id
    add_index :endowment_lines, :endowment_id
  end
end
