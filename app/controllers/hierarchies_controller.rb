class HierarchiesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /hierarchies
  # GET /hierarchies.json
  def index
    @title = t('view.hierarchies.index_title')
    @hierarchies = Hierarchy.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hierarchies }
    end
  end

  # GET /hierarchies/1
  # GET /hierarchies/1.json
  def show
    @title = t('view.hierarchies.show_title')
    @hierarchy = Hierarchy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hierarchy }
    end
  end

  # GET /hierarchies/new
  # GET /hierarchies/new.json
  def new
    @title = t('view.hierarchies.new_title')
    @hierarchy = Hierarchy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hierarchy }
    end
  end

  # GET /hierarchies/1/edit
  def edit
    @title = t('view.hierarchies.edit_title')
    @hierarchy = Hierarchy.find(params[:id])
  end

  # POST /hierarchies
  # POST /hierarchies.json
  def create
    @title = t('view.hierarchies.new_title')
    @hierarchy = Hierarchy.new(params[:hierarchy])

    respond_to do |format|
      if @hierarchy.save
        format.html { redirect_to @hierarchy, notice: t('view.hierarchies.correctly_created') }
        format.json { render json: @hierarchy, status: :created, location: @hierarchy }
      else
        format.html { render action: 'new' }
        format.json { render json: @hierarchy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hierarchies/1
  # PUT /hierarchies/1.json
  def update
    @title = t('view.hierarchies.edit_title')
    @hierarchy = Hierarchy.find(params[:id])

    respond_to do |format|
      if @hierarchy.update_attributes(params[:hierarchy])
        format.html { redirect_to @hierarchy, notice: t('view.hierarchies.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hierarchy.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_hierarchy_url(@hierarchy), alert: t('view.hierarchies.stale_object_error')
  end

  # DELETE /hierarchies/1
  # DELETE /hierarchies/1.json
  def destroy
    @hierarchy = Hierarchy.find(params[:id])
    @hierarchy.destroy

    respond_to do |format|
      format.html { redirect_to hierarchies_url }
      format.json { head :ok }
    end
  end
end
