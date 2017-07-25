class Configs::DocketsController < ApplicationController
  before_action :set_firefighter
  before_action :set_docket, only: [:show, :edit, :update, :destroy]

  layout false

  respond_to :html

  def show
    render partial: 'show'
  end

  def new
    @docket = Docket.new(firefighter_id: @firefighter_id)
    render partial: 'form'
  end

  def edit
    render partial: 'form'
  end

  def create
    @firefighter = Firefighter.find(@firefighter_id)
    @docket = @firefighter.dockets.new(docket_params)
    @docket.save
    redirect_to_firefighter
  end

  def update
    @docket.update(docket_params)
    redirect_to_firefighter
  end

  def destroy
    @docket.destroy
    redirect_to_firefighter
  end

  private

  def redirect_to_firefighter
    redirect_to configs_firefighter_path(@firefighter_id)
  end

  def set_firefighter
    @firefighter_id = params[:firefighter_id]
  end

  def set_docket
    @firefighter = Firefighter.find(@firefighter_id)
    @docket = @firefighter.dockets.find(params[:id])
  end

  def docket_params
    (params[:docket] || {}).merge(firefighter_id: @firefighter_id)
  end
end
