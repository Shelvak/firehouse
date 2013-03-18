class VehiclesController < ApplicationController
  before_filter :get_intervention

  def new
    @title = t('view.vehicles.new_title')
    @vehicle = @mobile_intervention.vehicles.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vehicle }
    end
  end

  def edit
    @title = t('view.vehicles.edit_title')
    @vehicle = Vehicle.find(params[:id])
  end

  def create
    @title = t('view.vehicles.new_title')
    @vehicle = @mobile_intervention.vehicles.build(params[:vehicle])

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to [@intervention, @mobile_intervention], notice: t('view.vehicles.correctly_created') }
        format.json { render json: [@intervention, @mobile_intervention], status: :created, location: @vehicle }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @title = t('view.vehicles.edit_title')
    @vehicle = Vehicle.find(params[:id])

    respond_to do |format|
      if @vehicle.update_attributes(params[:vehicle])
        format.html { redirect_to [@intervention, @mobile_intervention], notice: t('view.vehicles.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @intervention, @mobile_intervention, @vehicle], alert: t('view.vehicles.stale_object_error')
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to vehicles_url }
      format.json { head :ok }
    end
  end

  private
    def get_intervention
      @intervention = Intervention.includes(:mobile_intervention).find(params[:intervention_id])
      @mobile_intervention = @intervention.mobile_intervention
    end
end
