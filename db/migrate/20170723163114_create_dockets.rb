class CreateDockets < ActiveRecord::Migration
  def change
    create_table :dockets do |t|
      t.integer :firefighter_id, index: true
      t.string :file
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
