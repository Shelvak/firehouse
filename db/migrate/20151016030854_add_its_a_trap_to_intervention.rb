class AddItsATrapToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :its_a_trap, :boolean, default: false
  end
end
