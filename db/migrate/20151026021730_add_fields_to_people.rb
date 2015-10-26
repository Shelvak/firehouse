class AddFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :genre, :string
  end
end
