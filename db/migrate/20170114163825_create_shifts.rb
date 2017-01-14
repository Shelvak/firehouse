class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.references :firefighter, index: true, null: false
      t.datetime :start_at, null: false
      t.datetime :finish_at
      t.integer :kind, index: true, null: false
      t.string :notes

      t.timestamps
    end

  end
end
