class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :intervention_id
      t.datetime :created_at
    end
  end
end
