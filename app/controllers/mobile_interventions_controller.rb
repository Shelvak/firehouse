class MobileInterventionsController < ApplicationController
  before_filter :get_intervention
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /mobile_intervention/1
  # GET /mobile_intervention/1.json
  def show
    @title = t('view.mobile_interventions.show_title')
    @mobile_intervention = if @endowment.mobile_intervention.nil?
                             @endowment.create_mobile_intervention
                           else
                             @endowment.mobile_intervention
                           end

    @buildings = @mobile_intervention.buildings.order(:id)
    @people    = @mobile_intervention.people.order(:id)
    @supports  = @mobile_intervention.supports.order(:id)
    @vehicles  = @mobile_intervention.vehicles.order(:id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mobile_intervention }
    end
  end

  # PUT /mobile_intervention/1
  # PUT /mobile_intervention/1.json
  def update
    @title = t('view.mobile_interventions.edit_title')
    mobile_intervention = @endowment.mobile_intervention

    if mobile_intervention.update_attributes(params[:mobile_intervention])
      redirect_to intervention_endowment_mobile_intervention_path(
        @intervention, @endowment
      ), notice: t('view.mobile_interventions.correctly_updated')
    else
      render action: 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_endowment_mobile_intervention_path(
      @intervention, @endowment, @mobile_intervention
    ), alert: t('view.mobile_interventions.stale_object_error')
  end

  private

    def get_intervention
      @intervention = Intervention.find(params[:intervention_id])
      @endowment = Endowment.find params[:endowment_id]
    end
end
