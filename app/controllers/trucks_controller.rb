class TrucksController < ApplicationController
  
  # GET /trucks
  # GET /trucks.json
  def index
    @title = t('view.trucks.index_title')
    @trucks = Truck.page(params[:page])

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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @truck }
    end
  end

  # GET /trucks/new
  # GET /trucks/new.json
  def new
    @title = t('view.trucks.new_title')
    @truck = Truck.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @truck }
    end
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

    respond_to do |format|
      if @truck.save
        format.html { redirect_to @truck, notice: t('view.trucks.correctly_created') }
        format.json { render json: @truck, status: :created, location: @truck }
      else
        format.html { render action: 'new' }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trucks/1
  # PUT /trucks/1.json
  def update
    @title = t('view.trucks.edit_title')
    @truck = Truck.find(params[:id])

    respond_to do |format|
      if @truck.update_attributes(params[:truck])
        format.html { redirect_to @truck, notice: t('view.trucks.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_truck_url(@truck), alert: t('view.trucks.stale_object_error')
  end

  # DELETE /trucks/1
  # DELETE /trucks/1.json
  def destroy
    @truck = Truck.find(params[:id])
    @truck.destroy

    respond_to do |format|
      format.html { redirect_to trucks_url }
      format.json { head :ok }
    end
  end
end
