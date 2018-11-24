class ChangeKindNotesToText < ActiveRecord::Migration
  def change
    change_column :interventions, :kind_notes, :text
  end
end
