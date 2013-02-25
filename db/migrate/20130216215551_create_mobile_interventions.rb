class CreateMobileInterventions < ActiveRecord::Migration
  def change
    create_table :mobile_interventions do |t|
      t.datetime :date
      t.string :emergency
      t.text :observations
      t.integer :intervention_id

      t.timestamps
    end
  end
end
