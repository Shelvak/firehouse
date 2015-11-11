class AddMobileIntIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :mobile_intervention_id, :integer

    add_index :people, :building_id
    add_index :people, :vehicle_id
    add_index :people, :mobile_intervention_id
  end
end
