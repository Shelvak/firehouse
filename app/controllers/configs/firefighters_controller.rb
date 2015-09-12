class Configs::FirefightersController < ApplicationController
  before_filter :authenticate_user!
  before_action :check_parameters, only: [:create, :update]

  check_authorization
  load_and_authorize_resource

  # GET /firefighters
  # GET /firefighters.json
  def index
    @title = t('view.firefighters.index_title')
    @firefighters = Firefighter.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @firefighters }
    end
  end

  # GET /firefighters/1
  # GET /firefighters/1.json
  def show
    @title = t('view.firefighters.show_title')
    @firefighter = Firefighter.find(params[:id])

    render partial: 'show', content_type: 'text/html'
  end

  # GET /firefighters/new
  # GET /firefighters/new.json
  def new
    @title = t('view.firefighters.new_title')
    @firefighter = Firefighter.new
    render partial: 'new', content_type: 'text/html'
  end

  # GET /firefighters/1/edit
  def edit
    @title = t('view.firefighters.edit_title')
    @firefighter = Firefighter.find(params[:id])
    render partial: 'edit', content_type: 'text/html'
  end

  # POST /firefighters
  # POST /firefighters.json
  def create
    @title = t('view.firefighters.new_title')
    @firefighter = Firefighter.new(params[:firefighter])

    if @firefighter.save
      # render partial: 'firefighter', locals: { firefighter: @firefighter }, content_type: 'text/html'
      js_redirect to: configs_firefighters_path
    else
      render partial: 'new', status: :unprocessable_entity, content_type: 'text/html'
    end
  end

  # PUT /firefighters/1
  # PUT /firefighters/1.json
  def update
    @title = t('view.firefighters.edit_title')
    @firefighter = Firefighter.find(params[:id])

    if @firefighter.update_attributes(params[:firefighter])
      # render partial: 'firefighter', locals: { firefighter: @firefighter }, content_type: 'text/html'
      js_redirect to: configs_firefighters_path
    else
      render partial: 'edit', status: :unprocessable_entity, content_type: 'text/html'
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_configs_firefighter_url(@firefighter),
      alert: t('view.firefighters.stale_object_error')
  end

  # DELETE /firefighters/1
  # DELETE /firefighters/1.json
  def destroy
    @firefighter = Firefighter.find(params[:id])
    @firefighter.destroy

    render nothing: true, content_type: 'text/html'
  end

  private
    def check_parameters
      parameters_to_check = %w(sex blood_type blood_factor)
      parameters_to_check.each do |p|
        params['firefighter'][p] = params['firefighter'][p].first if params['firefighter'][p]
      end
    end
end
