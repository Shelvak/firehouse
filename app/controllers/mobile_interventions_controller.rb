class MobileInterventionsController < ApplicationController
  before_filter :get_intervention

  # GET /mobile_intervention/1
  # GET /mobile_intervention/1.json
  def show
    @title = t('view.mobile_interventions.show_title')
    @mobile_intervention = if @endowment.mobile_intervention.nil?
                             @endowment.create_mobile_intervention
                           else
                             @endowment.mobile_intervention
                           end

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

    respond_to do |format|
      if mobile_intervention.update_attributes(params[:mobile_intervention])
        format.html { redirect_to intervention_endowment_mobile_intervention_path(
          @intervention, @endowment
        ), notice: t('view.mobile_interventions.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mobile_intervention.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_endowment_mobile_intervention_path(@intervention, @endowment, @mobile_intervention), alert: t('view.mobile_interventions.stale_object_error')
  end

  private

  def get_intervention
    @intervention = Intervention.find(params[:intervention_id])
    @endowment = Endowment.find params[:endowment_id]
  end
end
