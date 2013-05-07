class ChangeInterventionIdToEndowementId < ActiveRecord::Migration
  def change
    rename_column :mobile_interventions, :intervention_id, :endowement_id
  end
end
