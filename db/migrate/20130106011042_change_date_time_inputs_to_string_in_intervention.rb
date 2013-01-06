class ChangeDateTimeInputsToStringInIntervention < ActiveRecord::Migration
  def up
    change_column :interventions, :out_at, :string, limit: 5
    change_column :interventions, :arrive_at, :string, limit: 5
    change_column :interventions, :back_at, :string, limit: 5
    change_column :interventions, :in_at, :string, limit: 5
  end

  def down
    change_column :interventions, :out_at, :datetime
    change_column :interventions, :arrive_at, :datetime
    change_column :interventions, :back_at, :datetime
    change_column :interventions, :in_at, :datetime
  end
end
