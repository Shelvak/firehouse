class BuildingsController < ApplicationController
  before_filter :get_mobile_intervention

  # GET /buildings/new
  # GET /buildings/new.json
  def new
    @title = t('view.buildings.modal.involved_building')
    @building = Building.new
    render partial: 'new'
  end

  # GET /buildings/1/edit
  def edit
    @title = t('view.buildings.modal.involved_building')
    @building = Building.find(params[:id])
    render partial: 'edit'
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @title = t('view.buildings.modal.involved_building')
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
    @title = t('view.buildings.modal.involved_building')
    @building = Building.find(params[:id])

    if @building.update_attributes(params[:building])
      #todo insertar con ajax
      js_notify message: t('view.buildings.correctly_created'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @intervention, @endowment, 'mobile_intervention',
                @building], alert: t('view.buildings.stale_object_error')
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building = Building.find(params[:id])
    @building.destroy
    #todo: tambien con ajax
    js_redirect reload: true
  end

  private
    def get_mobile_intervention
      @endowment = Endowment.find(params[:endowment_id])
      @intervention = @endowment.intervention
      @mobile_intervention = @endowment.mobile_intervention
    end
end
