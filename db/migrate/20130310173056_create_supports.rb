class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.string :support_type
      t.string :number
      t.string :responsible
      t.string :driver
      t.string :owner
      t.integer :mobile_intervention_id

      t.timestamps
    end
  end
end
