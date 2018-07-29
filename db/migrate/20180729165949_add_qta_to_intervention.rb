class AddQtaToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :qta, :boolean, default: false
  end
end
