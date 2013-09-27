class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name, default: 'open'
      t.integer :trackeable_id
      t.string :trackeable_type
      t.integer :user_id

      t.timestamps
    end

    add_index :statuses, :user_id
    add_index :statuses, :trackeable_id
  end
end
