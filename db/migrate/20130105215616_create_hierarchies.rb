class CreateHierarchies < ActiveRecord::Migration
  def change
    create_table :hierarchies do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :hierarchies, :name
  end
end
