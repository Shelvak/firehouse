class InterventionsController < ApplicationController
  before_filter :authenticate_user!, except: [:console_create, :console_trap_sign]

  check_authorization except: [:console_create]
  load_and_authorize_resource except: [:console_create, :console_trap_sign]

  # GET /interventions
  # GET /interventions.json
  def index
    @title = t('view.interventions.index_title')
    @from, @to = make_datetime_range(params[:interval])

    @interventions = intervention_scope.includes(:intervention_type)
    @interventions = @interventions.between(@from, @to) if params[:interval]
    @interventions = @interventions.where(intervention_type_id: params[:type]) if params[:type]
    @interventions = @interventions.where(receptor_id: params[:user]) if params[:user]
    @interventions = @interventions.order(created_at: :desc).page(params[:page])
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
    @intervention = intervention_scope.find(params[:id])
    @title = t('view.interventions.edit_title', title: @intervention.to_s)
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

    if @intervention.update(params[:intervention])
      if params[:no_refresh].present? && params[:no_refresh] == 'true'
        render nothing: true
      elsif html_request
        redirect_to @intervention, notice: t('view.interventions.correctly_updated')
      else
        render action: 'edit', layout: (html_request ? 'application' : false)
      end
    else
      render action: 'edit', layout: (html_request ? 'application' : false)
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_url(@intervention),
                alert: t('view.interventions.stale_object_error')
  end

  # no deberiamos tener deletes.
  def destroy
    @intervention = intervention_scope.find(params[:id])
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

    if params[:sign] == 'qta'
      render text: 302 # emulate a redirect from js
    else #if params[:refresh].to_bool
      render 'edit', layout: false
    # else
    #   render nothing: true
    end
  end

  def console_create
    ::Rails.logger.info("CREANDO DESDE CONSOLA...")
    Intervention.create_by_lights(params)

    ::Rails.logger.info("CREACION TERMINADA...")
    render nothing: true
  end

  def console_trap_sign
    ::Rails.logger.info("CREANDO DESDE CONSOLA...")
    Intervention.last_console_creation_is_a_trap!

    ::Rails.logger.info("CREACION TERMINADA...")
    render nothing: true
  end

  private

    def intervention_scope
      case current_user.role
        when :radio, :firefighter
          Intervention.where(
            created_at: MAX_PERMITTED_HANDLE_DAYS.days.ago..Time.zone.now
          )
        else
          Intervention.all
      end
    end
end
