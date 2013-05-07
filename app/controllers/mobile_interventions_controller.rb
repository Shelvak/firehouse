class MobileInterventionsController < ApplicationController
  before_filter :get_intervention

  # GET /mobile_interventions
  # GET /mobile_interventions.json
  def index
    @title = t('view.mobile_interventions.index_title')
    @mobile_interventions = MobileIntervention.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mobile_interventions }
    end
  end

  # GET /mobile_interventions/1
  # GET /mobile_interventions/1.json
  def show
    @title = t('view.mobile_interventions.show_title')
    @mobile_intervention = MobileIntervention.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mobile_intervention }
    end
  end

  # GET /mobile_interventions/new
  # GET /mobile_interventions/new.json
  def new
    @title = t('view.mobile_interventions.new_title')
    @mobile_intervention = @endowment.build_mobile_intervention

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mobile_intervention }
    end
  end

  # GET /mobile_interventions/1/edit
  def edit
    @title = t('view.mobile_interventions.edit_title')
    @mobile_intervention = MobileIntervention.find(params[:id])
  end

  # POST /mobile_interventions
  # POST /mobile_interventions.json
  def create
    @title = t('view.mobile_interventions.new_title')
    @mobile_intervention = @endowment.build_mobile_intervention(params[:mobile_intervention])

    respond_to do |format|
      if @mobile_intervention.save
        format.html { redirect_to [@intervention, @endowment,  @mobile_intervention], notice: t('view.mobile_interventions.correctly_created') }
        format.json { render json: [@intervention, @endowment,  @mobile_intervention], status: :created, location: @mobile_intervention }
      else
        format.html { render action: 'new' }
        format.json { render json: @mobile_intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mobile_interventions/1
  # PUT /mobile_interventions/1.json
  def update
    @title = t('view.mobile_interventions.edit_title')
    @mobile_intervention = MobileIntervention.find(params[:id])

    respond_to do |format|
      if @mobile_intervention.update_attributes(params[:mobile_intervention])
        format.html { redirect_to [@intervention, @endowment,  @mobile_intervention], notice: t('view.mobile_interventions.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @mobile_intervention.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_endowement_mobile_intervention_path(@intervention, @endowment, @mobile_intervention), alert: t('view.mobile_interventions.stale_object_error')
  end

  # DELETE /mobile_interventions/1
  # DELETE /mobile_interventions/1.json
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
      @endowment = Endowment.find params[:endowement_id]
    end
end
