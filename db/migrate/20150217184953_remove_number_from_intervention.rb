class RemoveNumberFromIntervention < ActiveRecord::Migration
  def change
    remove_index :interventions, :number
    remove_column :interventions, :number
  end
end
