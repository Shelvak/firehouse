class InterventionsScoIdToScoName < ActiveRecord::Migration
  def change
    add_column :interventions, :sco_name, :string

    begin
      Intervention.connection.execute('SELECT * FROM scos;').each do |sco|
        Intervention.where(sco_id: sco['id']).update_all(sco_name: sco['full_name'])
      end
    rescue => e
      puts e
    end

    remove_column :interventions, :sco_id
  end
end
