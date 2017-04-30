class AddStatusToIntervention < ActiveRecord::Migration
  def change
    add_column :interventions, :status, :string, limit: 50, default: 'open'

    Intervention.where(
      id: Intervention.includes(:endowments).where.not(
        status: :finished, endowments: { in_at: nil }
      ).pluck(:id)
    ).update_all(status: :finished)
  end
end
