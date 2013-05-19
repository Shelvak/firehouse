class RemoveFirefighterIdFromEndowmentLines < ActiveRecord::Migration
  def change
    remove_index :endowment_lines, :firefighter_id
    remove_column :endowment_lines, :firefighter_id
  end
end
