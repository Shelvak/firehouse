class InterventionsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :active_sco?, only: [:new, :edit]

  check_authorization
  load_and_authorize_resource

  # GET /interventions
  # GET /interventions.json
  def index
    @title = t('view.interventions.index_title')
    @interventions = Intervention.includes(:intervention_type).page(params[:page])
  end

  # GET /interventions/1
  # GET /interventions/1.json
  def show
    @title = t('view.interventions.show_title')
    @intervention = Intervention.find(params[:id])
  end

  # GET /interventions/new
  # GET /interventions/new.json
  def new
    @title = t('view.interventions.new_title')
    @intervention = Intervention.new
    @intervention.build_informer unless @intervention.informer
  end

  # GET /interventions/1/edit
  def edit
    @title = t('view.interventions.edit_title')
    @intervention = Intervention.find(params[:id])
  end

  # POST /interventions
  # POST /interventions.json
  def create
    @title = t('view.interventions.new_title')
    @intervention = Intervention.new(params[:intervention])

    if @intervention.save
      @intervention.statuses.build(user_id: current_user.id).save
      redirect_to @intervention, notice: t('view.interventions.correctly_created')
    else
      render action: 'new'
    end
  end

  # PUT /interventions/1
  # PUT /interventions/1.json
  def update
    @title = t('view.interventions.edit_title')
    @intervention = Intervention.find(params[:id])

    if @intervention.update_attributes(params[:intervention])
      redirect_to @intervention, notice: t('view.interventions.correctly_updated')
    else
      render action: 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_url(@intervention),
                alert: t('view.interventions.stale_object_error')
  end

  # no deberiamos tener deletes.
  def destroy
    @intervention = Intervention.find(params[:id])
    @intervention.destroy

    redirect_to interventions_url
  end

  def autocomplete_for_truck_number
    trucks = Truck.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: trucks }
    end
  end

  def autocomplete_for_receptor_name
    receptors = User.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: receptors }
    end
  end

  def autocomplete_for_sco_name
    scos = Sco.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: scos }
    end
  end

  def autocomplete_for_firefighter_name
    firefighters = Firefighter.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: firefighters }
    end
  end

  def map
    @title = t('view.interventions.map_index.title')
    @interventions = Intervention.includes(:statuses).where(statuses: { name: 'open' })
  end

  private

    def active_sco?
      @no_active_sco = Sco.where(current: true).empty?
    end
end
