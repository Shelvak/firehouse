class Configs::ScosController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  layout ->(c) { c.request.xhr? ? false : 'application' }

  # GET /scos
  # GET /scos.json
  def index
    @title = t('view.scos.index_title')
    @scos = Sco.order('current DESC').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scos }
    end
  end

  # GET /scos/1
  # GET /scos/1.json
  def show
    @title = t('view.scos.show_title')
    @sco = Sco.find(params[:id])
  end

  # GET /scos/new
  # GET /scos/new.json
  def new
    @title = t('view.scos.new_title')
    @sco = Sco.new
  end

  # GET /scos/1/edit
  def edit
    @title = t('view.scos.edit_title')
    @sco = Sco.find(params[:id])
  end

  # POST /scos
  # POST /scos.json
  def create
    @title = t('view.scos.new_title')
    @sco = Sco.new(params[:sco])

    if @sco.save
      redirect_to [:configs, @sco], notice: t('view.scos.correctly_created')
    else
      render action: 'new'
    end
  end

  # PUT /scos/1
  # PUT /scos/1.json
  def update
    @title = t('view.scos.edit_title')
    @sco = Sco.find(params[:id])

    if @sco.update_attributes(params[:sco])
      redirect_to configs_scos_url, notice: t('view.scos.correctly_updated')
    else
      render action: 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_configs_sco_url(@sco), alert: t('view.scos.stale_object_error')
  end

  # DELETE /scos/1
  # DELETE /scos/1.json
  def destroy
    @sco = Sco.find(params[:id])
    @sco.destroy

    redirect_to configs_scos_url, notice: t('view.scos.correctly_destroyed')
  end

  def activate
    sco = Sco.find(params[:id])
    notice = if sco.activate!
               t('view.scos.activated')
             else
               t('view.scos.stale_object_error')
             end

    redirect_to configs_scos_url, notice: notice
  end

  def desactivate
    sco = Sco.find(params[:id])
    notice = if sco.desactivate!
               t('view.scos.desactivated')
             else
               t('view.scos.stale_object_error')
             end

    redirect_to configs_scos_url, notice: notice
  end
end
