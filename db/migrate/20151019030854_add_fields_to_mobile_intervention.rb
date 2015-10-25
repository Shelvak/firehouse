class AddFieldsToMobileIntervention < ActiveRecord::Migration
  def change
    add_column :mobile_interventions, :labors, :text
    add_column :mobile_interventions, :news,   :text
  end
end
