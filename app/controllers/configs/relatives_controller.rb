class Configs::RelativesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_firefighter
  before_filter :get_relative, only: [:edit, :update, :destroy]

  def new
    @relative = @firefighter.relatives.build
    render partial: 'new', content_type: 'text/html'
  end

  def edit
    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @relative = @firefighter.relatives.build(params[:relative])
    if @relative.save
      render partial: 'relative', content_type: 'text/html', locals: { relative: @relative }
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    if @relative.update_attributes(params[:relative])
      render partial: 'relative', content_type: 'text/html', locals: { relative: @relative }
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @relative.destroy
      render nothing: true, content_type: 'text/html'
    end
  end

  private
    def get_firefighter
      @firefighter = Firefighter.find(params[:firefighter_id])
    end

    def get_relative
      @relative = @firefighter.relatives.find(params[:id])
    end
end
