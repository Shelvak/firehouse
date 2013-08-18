class ChangeKindTypeForIntervention < ActiveRecord::Migration
  def up
    change_column :interventions, :kind, :string
  end

  def down
    change_column :interventions, :kind, :string, limit: 1
  end
end
