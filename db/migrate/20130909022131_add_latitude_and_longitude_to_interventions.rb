class AddLatitudeAndLongitudeToInterventions < ActiveRecord::Migration
  def change
    add_column :interventions, :latitude, :string
    add_column :interventions, :longitude, :string
  end
end
