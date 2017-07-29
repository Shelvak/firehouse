class AddLightPriorityToInterventionType < ActiveRecord::Migration
  def change
    add_column :intervention_types, :light_priority, :boolean, default: false
  end
end
