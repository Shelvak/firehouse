class Configs::InterventionTypesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def index
    @title = t('view.intervention_types.index_title')
    @intervention_types = InterventionType.only_fathers.
        order(:id).includes(:children)
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

    @intervention_type =  if @father = params[:father]
                            InterventionType.find(@father).
                                children.build(params[:intervention_type])
                          else
                            InterventionType.new(params[:intervention_type])
                          end

    if @intervention_type.save
      render_intervention_type
    else
      render partial: 'new', status: :unprocessable_entity, content_type: 'text/html'
    end
  end

  def update
    @title = t('view.intervention_types.edit_title')
    @intervention_type = InterventionType.find(params[:id])

    if @intervention_type.update_attributes(Hash[intervention_type_params])
      render_intervention_type
    else
      render partial: 'edit', status: :unprocessable_entity, content_type: 'text/html'
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
    @top_10_intervention_types = InterventionType.only_children.
      where('priority IS NOT NULL').order(:priority).limit(10)
  end

  def edit_priorities
    @children = InterventionType.only_children.order(:intervention_type_id, :id)
    render partial: 'edit_priorities', content_type: 'text/html'
  end

  def lights_priorities
    @all_by_lights = InterventionType.all_grouped_by_lights

    render 'lights_priorities'
  end

  # Put
  def lights_priority
    it = InterventionType.find(params[:id])
    it.mark_as_light_priority!
    redirect_to lights_priorities_configs_intervention_types_path, notice: "#{it.name} priorizado...."
  end

  def clean_light_priorities
    InterventionType.clean_light_priorities!(JSON.load(params[:lights]))
    redirect_to lights_priorities_configs_intervention_types_path, notice: "Limpias..."
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

  private

    def intervention_type_params
     params.require(:intervention_type).permit(
        :name, :priority, :father, :target, :callback, :color,
        :image, :remote_image_url, :intervention_type_id, :audio,
        :display_text, :emergency,
        lights: [:red, :blue, :green, :white, :yellow, :trap]
      )
    end

    def render_intervention_type
      case
        when request.format.js?
          render partial: 'intervention_type', locals: {
            intervention_type: @intervention_type,
            special_class: @intervention_type.is_root? ? 'type' : 'subtype'
          }
        else
          redirect_to configs_intervention_types_path, notice: t('view.generic.all_right')
        end
    end
end
