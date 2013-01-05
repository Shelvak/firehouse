class AddTruckOutDataToIntervention < ActiveRecord::Migration
  def up
    add_column :interventions, :truck_id, :integer
    add_column :interventions, :out_at, :datetime
    add_column :interventions, :arrive_at, :datetime 
    add_column :interventions, :back_at, :datetime 
    add_column :interventions, :in_at, :datetime 
    add_column :interventions, :out_mileage, :integer
    add_column :interventions, :arrive_mileage, :integer
    add_column :interventions, :back_mileage, :integer
    add_column :interventions, :in_mileage, :integer

    add_index :interventions, :truck_id
  end

  def down
    remove_index :interventions, :truck_id

    remove_column :interventions, :truck_id
    remove_column :interventions, :out_at
    remove_column :interventions, :arrive_at
    remove_column :interventions, :back_at
    remove_column :interventions, :in_at
    remove_column :interventions, :out_mileage
    remove_column :interventions, :arrive_mileage
    remove_column :interventions, :back_mileage
    remove_column :interventions, :in_mileage
  end
end
