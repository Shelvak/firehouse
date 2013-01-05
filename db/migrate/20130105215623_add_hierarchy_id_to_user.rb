class AddHierarchyIdToUser < ActiveRecord::Migration
  def up
    add_column :users, :hierarchy_id, :integer
  end

  def down
    remove_column :users, :hierarchy_id
  end
end
