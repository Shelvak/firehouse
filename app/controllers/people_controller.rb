class PeopleController < ApplicationController
  before_filter :get_intervention
  # GET /people
  # GET /people.json
  def index
    @title = t('view.people.index_title')
    @people = Person.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @title = t('view.people.show_title')
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @title = t('view.people.new_title')
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @title = t('view.people.edit_title')
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    @title = t('view.people.new_title')
    @person = @building.persons.build(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to [@intervention, @mobile_intervention], notice: t('view.people.correctly_created') }
        format.json { render json: [@intervention, @mobile_intervention], status: :created, location: @person }
      else
        format.html { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @title = t('view.people.edit_title')
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to [@intervention, @mobile_intervention], notice: t('view.people.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit',@intervention, @mobile_intervention, @building, @person], alert: t('view.people.stale_object_error')
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to [@intervention, @mobile_intervention] }
      format.json { head :ok }
    end
  end

  private
    def get_intervention
      @intervention = Intervention.includes(:mobile_intervention).find(params[:intervention_id])
      @mobile_intervention = @intervention.mobile_intervention
      @building = Building.find(params[:building_id])
    end
end
