class AddNumberToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :number, :integer
  end
end
