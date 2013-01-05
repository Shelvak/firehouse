class RemoveHierarchyIdToIntervention < ActiveRecord::Migration
  def up
    remove_column :interventions, :hierarchy_id
  end

  def down
    add_column :interventions, :hierarchy_id, :integer
  end
end
