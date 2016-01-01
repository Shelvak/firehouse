class ChangeFirefightersColumns < ActiveRecord::Migration
  def change
    rename_column :firefighters, :number_of_childrens, :number_of_children
    remove_column :firefighters, :hierarchy
    add_column :firefighters, :hierarchy_id, :integer
  end
end
