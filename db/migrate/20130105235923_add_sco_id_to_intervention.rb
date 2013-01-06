class AddScoIdToIntervention < ActiveRecord::Migration
  def up
    add_column :interventions, :sco_id, :integer
  end

  def down
    remove_column :interventions, :sco_id
  end
end
