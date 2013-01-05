class CreateInformers < ActiveRecord::Migration
  def change
    create_table :informers do |t|
      t.string :full_name, null: false
      t.integer :nid, null: false
      t.string :phone
      t.string :address
      t.integer :intervention_id, null: false

      t.timestamps
    end

    add_index :informers, :intervention_id
  end
end
