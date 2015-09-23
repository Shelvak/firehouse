class CreateRelatives < ActiveRecord::Migration
  def change
    create_table :relatives do |t|
      t.string :details
      t.string :dni
      t.string :last_name
      t.string :name
      t.string :relation_type
      t.date :birth_date
      t.boolean :alive
      t.integer :firefighter_id
      t.timestamps
    end

    add_index :relatives, [:dni, :firefighter_id], unique: true
  end
end
