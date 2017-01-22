class Configs::ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html

  check_authorization
  load_and_authorize_resource

  def index
    @shifts = Shift.page(params[:page])
    respond_with(:configs, @shifts)
  end

  def show
    respond_with(:configs, @shift)
  end

  def new
    @shift = Shift.new
    respond_with(:configs, @shift)
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    @shift.save
    respond_with(:configs, @shift)
  end

  def update
    @shift.update(shift_params)
    respond_with(:configs, @shift)
  end

  def destroy
    @shift.destroy
    respond_with(:configs, @shift)
  end

  def reports
    @title = t('view.shifts.reports.title')
    @from, @to = make_datetime_range(params[:interval])
    @shifts_report = Shift.reports_between(@from, @to)

    respond_with(@shifts_report)
  end

  private
    def set_shift
      @shift = Shift.find(params[:id])
    end

    def shift_params
      params.require(:shift).permit(:firefighter_id, :start_at, :finish_at, :kind, :notes)
    end
end
