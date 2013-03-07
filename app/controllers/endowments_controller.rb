class EndowmentsController < ApplicationController
  
  # GET /endowments
  # GET /endowments.json
  def index
    @title = t('view.endowments.index_title')
    @endowments = Endowment.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @endowments }
    end
  end

  # GET /endowments/1
  # GET /endowments/1.json
  def show
    @title = t('view.endowments.show_title')
    @endowment = Endowment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @endowment }
    end
  end

  # GET /endowments/new
  # GET /endowments/new.json
  def new
    @title = t('view.endowments.new_title')
    @endowment = Endowment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @endowment }
    end
  end

  # GET /endowments/1/edit
  def edit
    @title = t('view.endowments.edit_title')
    @endowment = Endowment.find(params[:id])
  end

  # POST /endowments
  # POST /endowments.json
  def create
    @title = t('view.endowments.new_title')
    @endowment = Endowment.new(params[:endowment])

    respond_to do |format|
      if @endowment.save
        format.html { redirect_to @endowment, notice: t('view.endowments.correctly_created') }
        format.json { render json: @endowment, status: :created, location: @endowment }
      else
        format.html { render action: 'new' }
        format.json { render json: @endowment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /endowments/1
  # PUT /endowments/1.json
  def update
    @title = t('view.endowments.edit_title')
    @endowment = Endowment.find(params[:id])

    respond_to do |format|
      if @endowment.update_attributes(params[:endowment])
        format.html { redirect_to @endowment, notice: t('view.endowments.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @endowment.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_endowment_url(@endowment), alert: t('view.endowments.stale_object_error')
  end

  # DELETE /endowments/1
  # DELETE /endowments/1.json
  def destroy
    @endowment = Endowment.find(params[:id])
    @endowment.destroy

    respond_to do |format|
      format.html { redirect_to endowments_url }
      format.json { head :ok }
    end
  end
end
