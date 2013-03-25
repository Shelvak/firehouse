class FirefightersController < ApplicationController
  
  # GET /firefighters
  # GET /firefighters.json
  def index
    @title = t('view.firefighters.index_title')
    @firefighters = Firefighter.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @firefighters }
    end
  end

  # GET /firefighters/1
  # GET /firefighters/1.json
  def show
    @title = t('view.firefighters.show_title')
    @firefighter = Firefighter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @firefighter }
    end
  end

  # GET /firefighters/new
  # GET /firefighters/new.json
  def new
    @title = t('view.firefighters.new_title')
    @firefighter = Firefighter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @firefighter }
    end
  end

  # GET /firefighters/1/edit
  def edit
    @title = t('view.firefighters.edit_title')
    @firefighter = Firefighter.find(params[:id])
  end

  # POST /firefighters
  # POST /firefighters.json
  def create
    @title = t('view.firefighters.new_title')
    @firefighter = Firefighter.new(params[:firefighter])

    respond_to do |format|
      if @firefighter.save
        format.html { redirect_to @firefighter, notice: t('view.firefighters.correctly_created') }
        format.json { render json: @firefighter, status: :created, location: @firefighter }
      else
        format.html { render action: 'new' }
        format.json { render json: @firefighter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /firefighters/1
  # PUT /firefighters/1.json
  def update
    @title = t('view.firefighters.edit_title')
    @firefighter = Firefighter.find(params[:id])

    respond_to do |format|
      if @firefighter.update_attributes(params[:firefighter])
        format.html { redirect_to @firefighter, notice: t('view.firefighters.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @firefighter.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_firefighter_url(@firefighter), alert: t('view.firefighters.stale_object_error')
  end

  # DELETE /firefighters/1
  # DELETE /firefighters/1.json
  def destroy
    @firefighter = Firefighter.find(params[:id])
    @firefighter.destroy

    respond_to do |format|
      format.html { redirect_to firefighters_url }
      format.json { head :ok }
    end
  end
end
