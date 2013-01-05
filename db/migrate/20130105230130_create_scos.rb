class CreateScos < ActiveRecord::Migration
  def change
    create_table :scos do |t|
      t.string :full_name, null: false
      t.boolean :current, default: false

      t.timestamps
    end
  end
end
