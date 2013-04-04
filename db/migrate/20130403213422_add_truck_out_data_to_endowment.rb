class AddTruckOutDataToEndowment < ActiveRecord::Migration
  def change
    add_column :endowments, :truck_id, :integer
    add_column :endowments, :out_at, :string, limit: 5
    add_column :endowments, :arrive_at, :string, limit: 5 
    add_column :endowments, :back_at, :string, limit: 5 
    add_column :endowments, :in_at, :string, limit: 5 
    add_column :endowments, :out_mileage, :integer
    add_column :endowments, :arrive_mileage, :integer
    add_column :endowments, :back_mileage, :integer
    add_column :endowments, :in_mileage, :integer

    add_index :endowments, :truck_id
  end
end
