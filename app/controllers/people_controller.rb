class PeopleController < ApplicationController
  before_filter :get_intervention

  def index
    @title = t('view.people.index_title')
    @people = Person.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  def show
    @title = t('view.people.show_title')
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  def new
    @title = t('view.people.modal.involved_person')
    @person = (@building || @vehicle).people.build

    render partial: 'new', content_type: 'text/html'
  end

  def edit
    @title = t('view.people.modal.involved_person')
    @person = Person.find(params[:id])
    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @title = t('view.people.modal.involved_person')
    @person = @building.people.build(params[:person]) if @building
    @person = @vehicle.people.build(params[:person]) if @vehicle

    if @person.save
      js_notify message: t('view.people.correctly_created'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.people.modal.involved_person')
    @person = Person.find(params[:id])

      if @person.update_attributes(params[:person])
        js_notify message: t('view.people.correctly_updated'), type: 'info', time: 2000
        js_redirect reload: true
      else
        render partial: 'edit', status: :unprocessable_entity
      end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @intervention, @endowment, 'mobile_intervention',
     (@vehicle || @building), @person], alert: t('view.people.stale_object_error')
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    js_redirect reload: true
  end

  private
    def get_intervention
      @endowment = Endowment.find(params[:endowment_id])
      @mobile_intervention = @endowment.mobile_intervention
      @intervention = @endowment.intervention
      @building = @mobile_intervention.buildings.find(params[:building_id]) if params[:building_id]
      @vehicle = @mobile_intervention.vehicles.find(params[:vehicle_id]) if params[:vehicle_id]
    end
end
