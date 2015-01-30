class AddLightsToInterventionTypes < ActiveRecord::Migration
  def change
    add_column :intervention_types, :lights, :text
  end
end
