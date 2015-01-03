class CreateLights < ActiveRecord::Migration
  def change
    create_table :lights do |t|
      t.string :kind
      t.string :color
      t.integer :intensity, default: 0

      t.timestamps
    end
  end
end
