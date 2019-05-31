class EndowmentsController < ApplicationController
  def create
    @intervention = Intervention.find(params[:intervention_id])
    endowment = @intervention.endowments.create!(number: params[:number] || 2)

    body = render_to_string(
      partial: 'interventions/endowment_new_form',
      formats: [:html],
      locals: {
        endowment: endowment
      }
    )

    render json: { content: body }
  end

  def update
    endowment = Endowment.find_by(
      id:              params[:id],
      intervention_id: params[:intervention_id]
    )

    endowment.update(params[:endowment])

    render json: endowment.changes_for_json
  end
end
