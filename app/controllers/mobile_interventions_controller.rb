class MobileInterventionsController < ApplicationController
  before_filter :get_intervention

  # GET /mobile_intervention
  # GET /mobile_interventions.json
  def index
    @title = t('view.mobile_interventions.index_title')
    @mobile_interventions = MobileIntervention.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mobile_interventions }
    end
  end

  # GET /mobile_intervention/1
  # GET /mobile_intervention/1.json
  def show
    @title = t('view.mobile_interventions.show_title')
    @endowment = Endowment.find(params[:endowment_id])
    @intervention = @endowment.intervention
    @mobile_intervention = @endowment.build_mobile_intervention

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mobile_intervention }
    end
  end

  # GET /mobile_intervention/new
  # GET /mobile_intervention/new.json
  def new
    @title = t('view.mobile_interventions.new_title')
    @mobile_intervention = @endowment.build_mobile_intervention

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mobile_intervention }
    end
  end

  # GET /mobile_intervention/1/edit
  def edit
    @title = t('view.mobile_interventions.edit_title')
    @mobile_intervention = MobileIntervention.find(params[:id])
  end

  # POST /mobile_intervention
  # POST /mobile_intervention.json
  def create
    @title = t('view.mobile_interventions.new_title')
    @mobile_intervention = @endowment.build_mobile_intervention(params[:mobile_intervention])

    respond_to do |format|
      if @mobile_intervention.save
        format.html { redirect_to intervention_endowment_mobile_intervention_path(@intervention, @endowment,  @mobile_intervention), notice: t('view.mobile_interventions.correctly_created') }
        format.json { render json: intervention_endowment_mobile_intervention_path(@intervention, @endowment,  @mobile_intervention), status: :created, location: @mobile_intervention }
      else
        format.html { render action: 'new' }
        format.json { render json: @mobile_intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mobile_intervention/1
  # PUT /mobile_intervention/1.json
  def update
    @title = t('view.mobile_interventions.edit_title')
    @mobile_intervention = MobileIntervention.find(params[:id])

    respond_to do |format|
      if @mobile_intervention.update_attributes(params[:mobile_intervention])
        format.html { redirect_to intervention_endowment_mobile_intervention_path(@intervention, @endowment,  @mobile_intervention), notice: t('view.mobile_interventions.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mobile_intervention.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_endowment_mobile_intervention_path(@intervention, @endowment, @mobile_intervention), alert: t('view.mobile_interventions.stale_object_error')
  end

  # DELETE /mobile_intervention/1
  # DELETE /mobile_intervention/1.json
  def destroy
    @mobile_intervention = MobileIntervention.find(params[:id])
    @mobile_intervention.destroy

    respond_to do |format|
      format.html { redirect_to @intervention }
      format.json { head :ok }
    end
  end

  private
    def get_intervention
      @intervention = Intervention.find(params[:intervention_id])
      @endowment = Endowment.find params[:endowment_id]
    end
end
