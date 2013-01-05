class ScosController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource

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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sco }
    end
  end

  # GET /scos/new
  # GET /scos/new.json
  def new
    @title = t('view.scos.new_title')
    @sco = Sco.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sco }
    end
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

    respond_to do |format|
      if @sco.save
        format.html { redirect_to @sco, notice: t('view.scos.correctly_created') }
        format.json { render json: @sco, status: :created, location: @sco }
      else
        format.html { render action: 'new' }
        format.json { render json: @sco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scos/1
  # PUT /scos/1.json
  def update
    @title = t('view.scos.edit_title')
    @sco = Sco.find(params[:id])

    respond_to do |format|
      if @sco.update_attributes(params[:sco])
        format.html { redirect_to @sco, notice: t('view.scos.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sco.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_sco_url(@sco), alert: t('view.scos.stale_object_error')
  end

  # DELETE /scos/1
  # DELETE /scos/1.json
  def destroy
    @sco = Sco.find(params[:id])
    @sco.destroy

    respond_to do |format|
      format.html { redirect_to scos_url }
      format.json { head :ok }
    end
  end

  def activate
    sco = Sco.find(params[:id])

    if sco.activate!
      respond_to do |format|
        format.html { redirect_to scos_path, notice: t('view.scos.activated') }
      end
    end
  end
end
