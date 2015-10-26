class InsurancesController < ApplicationController
  before_filter :assign_type
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def new
    @title = t('view.insurances.modal.new_title')

    @insurance = @type.build_insurance

    render partial: 'new', content_type: 'text/html'
  end

  def edit
    @title = t('view.insurances.modal.edit_title')
    @insurance = Insurance.find(params[:id])

    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @title = t('view.insurances.modal.new_title')
    @insurance = @type.build_insurance(params[:insurance])

    if @insurance.save
      js_notify message: t('view.insurances.messages.correctly_created'),
                type: 'alert-info js-notify-18px-text', time: 2500
      render partial: 'insurances/show', content_type: 'text/html', locals: { type: @type }
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.insurances.modal.edit_title')
    @insurance = Insurance.find(params[:id])

    if @insurance.update_attributes(params[:insurance])
      js_notify message: t('view.insurances.messages.correctly_updated'),
                type: 'alert-info js-notify-18px-text', time: 2500
      render partial: 'insurances/insurance', content_type: 'text/html', locals: { type: @type, insurance: @insurance }
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @insurance = Insurance.find(params[:id])
    @insurance.destroy
    js_notify message: t('view.insurances.messages.correctly_destroyed'),
              type: 'alert-danger js-notify-18px-text', time: 2500

    # todo: cuando borro ya no puedo crear mas insurances porque se oculta el boton, ver como recargar
    render nothin: true, content_type: 'text/html'
  end

  private

    def assign_type
      if params[:building_id]
        @building = Building.find(params[:building_id])
      end

      if params[:vehicle_id]
        @vehicle = Vehicle.find(params[:vehicle_id])
      end

      @type = @building || @vehicle
    end
end
