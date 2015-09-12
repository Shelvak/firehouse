class AddSeveralFieldsToTruck < ActiveRecord::Migration
  def change
    add_column :trucks, :brand,          :string
    add_column :trucks, :brand_model,    :string
    add_column :trucks, :domain,         :string
    add_column :trucks, :federation,     :string
    add_column :trucks, :firehouse_name, :string
    add_column :trucks, :fuel_type,      :string
    add_column :trucks, :organization,   :string
    add_column :trucks, :truck_type,     :string
    add_column :trucks, :year,           :string

    add_column :trucks, :acquisition_date, :date

    add_column :trucks, :has_ownership,           :boolean
    add_column :trucks, :is_active,               :boolean
    add_column :trucks, :is_permanently_disabled, :boolean
  end
end
