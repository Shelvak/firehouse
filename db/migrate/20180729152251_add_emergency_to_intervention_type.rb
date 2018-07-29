class AddEmergencyToInterventionType < ActiveRecord::Migration
  def change
    add_column :intervention_types, :emergency, :boolean, default: false
  end
end
