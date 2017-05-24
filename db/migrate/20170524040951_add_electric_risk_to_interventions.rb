class AddElectricRiskToInterventions < ActiveRecord::Migration
  def change
    add_column :interventions, :electric_risk, :boolean, default: false
  end
end
