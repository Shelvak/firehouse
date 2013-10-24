class Configs::InterventionTypesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def index
    @title = t('view.intervention_types.index_title')
    @intervention_types = InterventionType.only_fathers.
        order(:id).includes(:childrens).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @intervention_types }
    end
  end

  def show
    @title = t('view.intervention_types.show_title')
    @intervention_type = InterventionType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @intervention_type }
    end
  end

  def new
    @title = t('view.intervention_types.new_title')
    @intervention_type = InterventionType.new
    @father = InterventionType.find(params[:father]) if params[:father]
    render partial: 'new', content_type: 'text/html'
  end

  def edit
    @intervention_type = InterventionType.find(params[:id])
    @title = t('view.intervention_types.edit_title',
               intervention_type: @intervention_type)
    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @title = t('view.intervention_types.new_title')
    @father = params[:father] if params[:father]
    if @father
      @intervention_type = InterventionType.find(params[:father]).
          childrens.build(params[:intervention_type])
    else
      InterventionType.new(params[:intervention_type])
    end

    if @intervention_type.save
      js_notify( message: t('view.intervention_types.correctly_created'), type:
                'alert-success js-notify-18px-text', time: 2500 )
      render @intervention_type, locals: { special_class: (
             @intervention_type.father ? 'subtype' : 'type' ) },
             content_type: 'text/html'
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.intervention_types.edit_title')
    @intervention_type = InterventionType.find(params[:id])

    if @intervention_type.update_attributes(params[:intervention_type])
      js_notify(message: t('view.intervention_types.correctly_updated'), type:
          'alert-success js-notify-18px-text', time: 2500)
      if params[:priority]
        render partial: 'configs/intervention_types/prority_item',
        locals: {intervention_type: @intervention_type}, content_type: 'text/html'
      else
        render partial: @intervention_type, locals: {special_class: (
        @intervention_type.father ? 'subtype' : 'type')}, content_type: 'text/html'
      end
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_intervention_type_url(@intervention_type), 
      alert: t('view.intervention_types.stale_object_error')
  end

  def destroy
    @intervention_type = InterventionType.find(params[:id])

    if @intervention_type.destroy
      js_notify(
        message: t('view.intervention_types.correctly_deleted'), 
        type: 'alert-danger js-notify-18px-text', time: 2500
      )
      render nothing: true, content_type: 'text/html'
    end
  end

  def priorities
    @title = t 'view.intervention_types.priorities'
    @top_10_intervention_types = InterventionType.only_childrens.
      where('priority IS NOT NULL').order(:priority).limit(10)
  end

  def edit_priorities
    @childrens = InterventionType.only_childrens.order(:intervention_type_id, :id)
    render partial: 'edit_priorities', content_type: 'text/html'
  end

  def set_priority
    (1..10).each do |i|
      old_intervention_type = InterventionType.where(priority: i).first
      old_intervention_type.update_attribute(:priority, nil) if old_intervention_type

      if params[i.to_s].present?
        InterventionType.find( params[i.to_s] ).update_attributes(priority: i)
      end
    end

    redirect_to priorities_configs_intervention_types_path
  end
end
