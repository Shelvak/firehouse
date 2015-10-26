class AddFieldsToBuildings < ActiveRecord::Migration
  def change
    rename_column :buildings, :roof,   :roof_type
    rename_column :buildings, :window, :window_type

    remove_column :buildings, :electrics, :string
    remove_column :buildings, :damage,    :string

    add_column :buildings, :affected_surface, :string
    add_column :buildings, :details,          :string
    add_column :buildings, :building_type,    :string
    add_column :buildings, :number_of_floors, :integer
    add_column :buildings, :number_of_rooms,  :integer
    add_column :buildings, :automatic_alert,  :boolean
    add_column :buildings, :extinguishers,    :boolean
    add_column :buildings, :fire_hydrants,    :boolean
  end
end
