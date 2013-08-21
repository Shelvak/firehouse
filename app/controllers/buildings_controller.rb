class BuildingsController < ApplicationController
  before_filter :get_mobile_intervention
  # GET /buildings
  # GET /buildings.json
  def index
    @title = t('view.buildings.index_title')
    @buildings = Building.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buildings }
    end
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
    @title = t('view.buildings.show_title')
    @building = Building.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @building }
    end
  end

  # GET /buildings/new
  # GET /buildings/new.json
  def new
    @title = t('view.buildings.modal.involved_building')
    @building = Building.new
    render partial: 'new', content_type: 'text/html'
  end

  # GET /buildings/1/edit
  def edit
    @title = t('view.buildings.modal.involved_building')
    @building = Building.find(params[:id])
    render partial: 'edit', content_type: 'text/html'
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @title = t('view.buildings.new_title')
    @building = @mobile_intervention.buildings.build(params[:building])
    if @building.save
      #todo insertar con ajax
      js_notify message: t('view.buildings.correctly_created'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.json
  def update
    @title = t('view.buildings.edit_title')
    @building = Building.find(params[:id])

    if @building.update_attributes(params[:building])
      #todo insertar con ajax
      js_notify message: t('view.buildings.correctly_created'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @mobile_intervention, @building], alert: t('view.buildings.stale_object_error')
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building = Building.find(params[:id])
    @building.destroy
    js_redirect reload: true
  end

  private
    def get_mobile_intervention
      @endowment = Endowment.find(params[:endowment_id])
      @intervention = @endowment.intervention
      @mobile_intervention = @endowment.mobile_intervention
    end
end
