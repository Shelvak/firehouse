class ChangeInterventionIdToEndowmentId < ActiveRecord::Migration
  def change
    rename_column :mobile_interventions, :intervention_id, :endowment_id
  end
end
