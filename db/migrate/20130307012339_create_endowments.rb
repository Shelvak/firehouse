class CreateEndowments < ActiveRecord::Migration
  def change
    create_table :endowments do |t|
      t.integer :number, null: false
      t.integer :intervention_id, null: false

      t.timestamps
    end

    add_index :endowments, :number
    add_index :endowments, :intervention_id
  end
end
