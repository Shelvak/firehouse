class AddDisplayTextToInterventionTypes < ActiveRecord::Migration
  def change
    add_column :intervention_types, :display_text, :string
  end
end
