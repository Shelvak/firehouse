class Configs::ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  respond_to :html

  check_authorization
  load_and_authorize_resource

  def index
    @shifts = shift_scope.page(params[:page])
    respond_with(:configs, @shifts)
  end

  def show
    respond_with(:configs, @shift)
  end

  def new
    @shift = shift_scope.new
    respond_with(:configs, @shift)
  end

  def edit
  end

  def create
    @shift = shift_scope.new(shift_params)
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
      @shift = shift_scope.find(params[:id])
    end

    def shift_scope
      if can?(:manage, Shift) || can?(:reports, Shift)
        Shift.all
      else
        current_user.firefighter.shifts
      end
    end

    def shift_params
      params.require(:shift).permit(:firefighter_id, :start_at, :finish_at, :kind, :notes)
    end
end
