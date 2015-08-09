class AddCallAtToInterventions < ActiveRecord::Migration
  def change
    add_column :interventions, :call_at, :datetime, null: false
  end
end
