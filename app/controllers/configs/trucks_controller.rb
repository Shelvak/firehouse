class Configs::TrucksController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /trucks
  # GET /trucks.json
  def index
    @title = t('view.trucks.index_title')
    @searchable = true
    @trucks = Truck.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trucks }
    end
  end

  # GET /trucks/1
  # GET /trucks/1.json
  def show
    @title = t('view.trucks.show_title')
    @truck = Truck.find(params[:id])
  end

  # GET /trucks/new
  # GET /trucks/new.json
  def new
    @title = t('view.trucks.new_title')
    @truck = Truck.new
  end

  # GET /trucks/1/edit
  def edit
    @title = t('view.trucks.edit_title')
    @truck = Truck.find(params[:id])
  end

  # POST /trucks
  # POST /trucks.json
  def create
    @title = t('view.trucks.new_title')
    @truck = Truck.new(params[:truck])

    if @truck.save
      redirect_to [:configs, @truck], notice: t('view.trucks.correctly_created')
    else
      render action: 'new'
    end
  end

  # PUT /trucks/1
  # PUT /trucks/1.json
  def update
    @title = t('view.trucks.edit_title')
    @truck = Truck.find(params[:id])

    if @truck.update_attributes(params[:truck])
      redirect_to [:configs, @truck], notice: t('view.trucks.correctly_updated')
    else
      render action: 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_truck_url(@truck), alert: t('view.trucks.stale_object_error')
  end

  # DELETE /trucks/1
  # DELETE /trucks/1.json
  def destroy
    @truck = Truck.find(params[:id])
    @truck.destroy

    redirect_to configs_trucks_url
  end
end
