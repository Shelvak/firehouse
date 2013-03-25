class CreateFirefighters < ActiveRecord::Migration
  def change
    create_table :firefighters do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :identification, null: false

      t.timestamps
    end
    
    add_index :firefighters, :firstname
    add_index :firefighters, :lastname
    add_index :firefighters, :identification, unique: true
  end
end
