class AddInterventionTypeIdToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :intervention_type_id, :integer
    remove_column :interventions, :kind
  end
end
