class CreateEndowments < ActiveRecord::Migration
  def change
    create_table :endowments do |t|
      t.integer :number, null: false

      t.timestamps
    end

    add_index :endowments, :number
  end
end
