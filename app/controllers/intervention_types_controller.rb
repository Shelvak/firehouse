class InterventionTypesController < ApplicationController

  # GET /intervention_types
  # GET /intervention_types.json
  def index
    @title = t('view.intervention_types.index_title')
    @intervention_types = InterventionType.where(intervention_type_id: nil).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @intervention_types }
    end
  end

  # GET /intervention_types/1
  # GET /intervention_types/1.json
  def show
    @title = t('view.intervention_types.show_title')
    @intervention_type = InterventionType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @intervention_type }
    end
  end

  # GET /intervention_types/new
  # GET /intervention_types/new.json
  def new
    @title = t('view.intervention_types.new_title')
    @intervention_type = InterventionType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @intervention_type }
    end
  end

  # GET /intervention_types/1/edit
  def edit
    @title = t('view.intervention_types.edit_title')
    @intervention_type = InterventionType.find(params[:id])
  end

  # POST /intervention_types
  # POST /intervention_types.json
  def create
    @title = t('view.intervention_types.new_title')
    if params[:father]
      @intervention_type = InterventionType.find(params[:father]).childrens.build(params[:intervention_type])
    else
      @intervention_type = InterventionType.new(params[:intervention_type])
    end

    respond_to do |format|
      if @intervention_type.save
        format.html { redirect_to intervention_types_url, notice: t('view.intervention_types.correctly_created') }
        format.json { render json: intervention_types_url, status: :created, location: @intervention_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @intervention_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /intervention_types/1
  # PUT /intervention_types/1.json
  def update
    @title = t('view.intervention_types.edit_title')
    @intervention_type = InterventionType.find(params[:id])

    respond_to do |format|
      if @intervention_type.update_attributes(params[:intervention_type])
        format.html { redirect_to intervention_types_url, notice: t('view.intervention_types.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @intervention_type.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_type_url(@intervention_type), alert: t('view.intervention_types.stale_object_error')
  end

  # DELETE /intervention_types/1
  # DELETE /intervention_types/1.json
  def destroy
    @intervention_type = InterventionType.find(params[:id])
    @intervention_type.destroy

    respond_to do |format|
      format.html { redirect_to intervention_types_url }
      format.json { head :ok }
    end
  end
end
