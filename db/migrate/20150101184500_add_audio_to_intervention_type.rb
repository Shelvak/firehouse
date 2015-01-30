class AddAudioToInterventionType < ActiveRecord::Migration
  def change
    add_column :intervention_types, :audio, :string
  end
end
