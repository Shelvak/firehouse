class VehiclesController < ApplicationController
  before_filter :get_intervention

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
    #todo: ajaxify
    if @vehicle.save
      js_notify message: t('view.vehicles.correctly_created'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.vehicles.modal.involved_vehicle')
    @vehicle = Vehicle.find(params[:id])
    #todo: ajaxify
    if @vehicle.update_attributes(params[:vehicle])
      js_notify message: t('view.vehicles.correctly_updated'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @intervention, @endowment, 'mobile_intervention',
                  @vehicle], alert: t('view.vehicles.stale_object_error')
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy
    #todo: ajaxify
    js_redirect reload: true
  end

  private
  def get_intervention
    @endowment = Endowment.find(params[:endowment_id])
    @intervention = @endowment.intervention
    @mobile_intervention = @endowment.mobile_intervention
  end
end
