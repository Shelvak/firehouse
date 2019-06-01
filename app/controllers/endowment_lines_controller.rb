class EndowmentLinesController < ApplicationController
  def update
    el = EndowmentLine.find_by(
      id:              params[:id],
      endowment_id:    params[:endowment_id]
    )

    el.update(params[:endowment_line])

    render json: el.changes_for_json
  end
end
