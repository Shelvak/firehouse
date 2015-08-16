class AddUserIdToFirefighters < ActiveRecord::Migration
  def change
    add_column :firefighters, :user_id, :integer

    add_index :firefighters, :user_id, unique: true
  end
end
