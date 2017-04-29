class AddStatusToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :status, :string, limit: 50, default: 'open'
  end
end
