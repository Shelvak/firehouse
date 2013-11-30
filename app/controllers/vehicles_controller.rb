class VehiclesController < ApplicationController
  before_filter :get_intervention
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def new
    @title = t('view.vehicles.modal.involved_vehicle')
    @vehicle = @mobile_intervention.vehicles.build

    render partial: 'new', content_type: 'text/html'
  end

  def edit
    @title = t('view.vehicles.modal.involved_vehicle')
    @vehicle = Vehicle.find(params[:id])

    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @title = t('view.vehicles.modal.involved_vehicle')
    @vehicle = @mobile_intervention.vehicles.build(params[:vehicle])
    @vehicle.number = @mobile_intervention.vehicles.size

    if @vehicle.save
      js_notify message: t('view.vehicles.correctly_created'),
                type: 'alert-info js-notify-18px-text', time: 2500
      render partial: 'mobile_interventions/vehicle', 
        locals: { vehicle: @vehicle }, content_type: 'text/html'
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.vehicles.modal.involved_vehicle')
    @vehicle = Vehicle.find(params[:id])

    if @vehicle.update_attributes(params[:vehicle])
      js_notify message: t('view.vehicles.correctly_updated'),
                type: 'alert-info js-notify-18px-text', time: 2500
      render partial: 'mobile_interventions/vehicle',
        locals: { vehicle: @vehicle }, content_type: 'text/html'
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to [
      'edit', @intervention, @endowment, 'mobile_intervention', @vehicle
    ], alert: t('view.vehicles.stale_object_error')
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy
    js_notify message: t('view.vehicles.correctly_destroyed'),
              type: 'alert-danger js-notify-18px-text', time: 2500

    render nothing: true, content_type: 'text/html'
  end

  private
    def get_intervention
      @endowment = Endowment.find(params[:endowment_id])
      @intervention = @endowment.intervention
      @mobile_intervention = @endowment.mobile_intervention
    end
end
