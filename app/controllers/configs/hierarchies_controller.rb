class Configs::HierarchiesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /hierarchies
  # GET /hierarchies.json
  def index
    @title = t('view.hierarchies.index_title')
    @searchable = true
    @hierarchies = Hierarchy.filtered_list(params[:q]).page(params[:page])
  end

  # GET /hierarchies/1
  # GET /hierarchies/1.json
  def show
    @title = t('view.hierarchies.show_title')
    @hierarchy = Hierarchy.find(params[:id])
  end

  # GET /hierarchies/new
  # GET /hierarchies/new.json
  def new
    @title = t('view.hierarchies.new_title')
    @hierarchy = Hierarchy.new
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

    if @hierarchy.save
      redirect_to [:configs, @hierarchy],
        notice: t('view.hierarchies.correctly_created')
    else
      render action: 'new'
    end
  end

  # PUT /hierarchies/1
  # PUT /hierarchies/1.json
  def update
    @title = t('view.hierarchies.edit_title')
    @hierarchy = Hierarchy.find(params[:id])

    if @hierarchy.update_attributes(params[:hierarchy])
      redirect_to [:configs, @hierarchy],
        notice: t('view.hierarchies.correctly_updated')
    else
      render action: 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_configs_hierarchy_url(@hierarchy),
      alert: t('view.hierarchies.stale_object_error')
  end

  # DELETE /hierarchies/1
  # DELETE /hierarchies/1.json
  def destroy
    @hierarchy = Hierarchy.find(params[:id])
    @hierarchy.destroy

    redirect_to configs_hierarchies_url
  end

  def autocomplete_for_hierarchy_name
    hierarchies = Hierarchy.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: hierarchies }
    end
  end
end
