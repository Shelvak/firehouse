class InterventionsController < ApplicationController
  before_filter :authenticate_user!, except: [:console_create]
  before_filter :active_sco?, only: [:new, :edit]

  check_authorization except: [:console_create]
  load_and_authorize_resource except: [:console_create]

  # GET /interventions
  # GET /interventions.json
  def index
    @title = t('view.interventions.index_title')
    @interventions = intervention_scope.includes(:intervention_type)
                       .order(created_at: :desc).page(params[:page])
  end

  # GET /interventions/1
  # GET /interventions/1.json
  def show
    @title = t('view.interventions.show_title')
    @intervention = intervention_scope.find(params[:id])
    @alerts = @intervention.alerts.order(:created_at)
  end

  # GET /interventions/new
  # GET /interventions/new.json
  def new
    @title = t('view.interventions.new_title')
    @intervention = intervention_scope.new
  end

  # GET /interventions/1/edit
  def edit
    @title = t('view.interventions.edit_title')
    @intervention = intervention_scope.find(params[:id])
  end

  # POST /interventions
  # POST /interventions.json
  def create
    @title = t('view.interventions.new_title')
    @intervention = intervention_scope.new(params[:intervention])

    if @intervention.save
      if request.format.html?
        redirect_to @intervention, notice: t('view.interventions.correctly_created')
      else
        render 'edit', layout: false
      end
    else
      render action: 'new'
    end
  end

  # PUT /interventions/1
  # PUT /interventions/1.json
  def update
    @title = t('view.interventions.edit_title')
    @intervention = intervention_scope.find(params[:id])
    html_request = request.format.html?

    if @intervention.update(params[:intervention]) && html_request
      redirect_to @intervention, notice: t('view.interventions.correctly_updated')
    else
      render 'edit', layout: (html_request ? 'application' : false)
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_url(@intervention),
                alert: t('view.interventions.stale_object_error')
  end

  # no deberiamos tener deletes.
  def destroy
    @intervention = intervention_scope.find(params[:id])
    @intervention.turn_off_alert
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
    @title = t('view.interventions.map.index.title')
    @interventions = intervention_scope.opened
  end

  # PUT (always came via ajax)
  def special_sign
    @intervention = intervention_scope.find(params[:id])
    @intervention.special_sign(params[:sign])

    if params[:refresh].to_bool
      render 'edit', layout: false
    else
      render nothing: true
    end
  end

  def console_create
    Intervention.create_by_lights(params)

    render nothing: true
  end

  private

    def active_sco?
      @no_active_sco = Sco.where(current: true).empty?
    end

    def intervention_scope
      case current_user.role
        when :radio, :firefighter
          current_user.interventions.where(
            created_at: MAX_PERMITTED_HANDLE_DAYS.days.ago..Time.zone.now
          )
        #when :shifts_admin, :reporter, :subofficer
        #  current_user.interventions
        else
          Intervention.all
      end
    end
end
