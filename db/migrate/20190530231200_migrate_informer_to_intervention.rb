class MigrateInformerToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :informer_name, :string
    add_column :interventions, :informer_nid, :string
    add_column :interventions, :informer_phone, :string
    add_column :interventions, :informer_address, :string

    Informer.joins(:intervention).find_each do |informer|
      informer.intervention.update_columns(
        informer_name:    informer.full_name,
        informer_nid:     informer.nid,
        informer_phone:   informer.phone,
        informer_address: informer.address,
      )
    end

    Informer.all.delete_all
  end
end
