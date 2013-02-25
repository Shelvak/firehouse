class BuildingsController < ApplicationController
  before_filter :get_intervention
  # GET /buildings
  # GET /buildings.json
  def index
    @title = t('view.buildings.index_title')
    @buildings = Building.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buildings }
    end
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
    @title = t('view.buildings.show_title')
    @building = Building.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @building }
    end
  end

  # GET /buildings/new
  # GET /buildings/new.json
  def new
    @title = t('view.buildings.new_title')
    @building = Building.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @building }
    end
  end

  # GET /buildings/1/edit
  def edit
    @title = t('view.buildings.edit_title')
    @building = Building.find(params[:id])
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @title = t('view.buildings.new_title')
    @building = @mobile_intervention.buildings.build(params[:building])

    respond_to do |format|
      if @building.save
        format.html { redirect_to [@intervention, @mobile_intervention], notice: t('view.buildings.correctly_created') }
        format.json { render json: [@intervention, @mobile_intervention], status: :created, location: @building }
      else
        format.html { render action: 'new' }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.json
  def update
    @title = t('view.buildings.edit_title')
    @building = Building.find(params[:id])

    respond_to do |format|
      if @building.update_attributes(params[:building])
        format.html { redirect_to [@intervention, @mobile_intervention], notice: t('view.buildings.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @intervention, @mobile_intervention, @building], alert: t('view.buildings.stale_object_error')
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    respond_to do |format|
      format.html { redirect_to [@intervention, @mobile_intervention] }
      format.json { head :ok }
    end
  end

  private
    def get_intervention
      @intervention = Intervention.includes(:mobile_intervention).find(params[:intervention_id])
      @mobile_intervention = @intervention.mobile_intervention
    end
end
