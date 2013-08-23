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
    @title = t('view.people.new_title')
    @person = (@building || @vehicle).persons.build

    render partial: 'new'
  end

  def edit
    @title = t('view.people.edit_title')
    @person = Person.find(params[:id])
  end

  def create
    @title = t('view.people.new_title')
    @person = @building.persons.build(params[:person]) if @building
    @person = @vehicle.persons.build(params[:person]) if @vehicle

    if @person.save
      redirect_to intervention_endowment_mobile_intervention_path(@endowment), notice: t('view.people.correctly_created')
    else
      redirect_to intervention_endowment_mobile_intervention_path(@endowment), notice: '---'
    end
  end

  def update
    @title = t('view.people.edit_title')
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to intervention_endowment_mobile_intervention_path(@intervention, @endowment,  @mobile_intervention), notice: t('view.people.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @mobile_intervention, @building, @person], alert: t('view.people.stale_object_error')
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to intervention_endowment_mobile_intervention_path(@intervention, @endowment,  @mobile_intervention) }
      format.json { head :ok }
    end
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
