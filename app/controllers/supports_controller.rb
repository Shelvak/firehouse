class SupportsController < ApplicationController
  before_filter :get_intervention

  def new
    @title = t('view.supports.modal.involved_support')
    @support = Support.new
    render partial: 'new', content_type: 'text/html'
  end

  def edit
    @title = t('view.supports.modal.involved_support')
    @support = Support.find(params[:id])
    render partial: 'edit', content_type: 'text/html'
  end

  def create
    @title = t('view.supports.modal.involved_support')
    @support = @mobile_intervention.supports.build(params[:support])
    #todo: ajaxify
    if @support.save
      js_notify message: t('view.supports.correctly_created'), type: 'info', time: 2000
      js_redirect reload: true
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.supports.modal.involved_support')
    @support = Support.find(params[:id])
    if @support.update_attributes(params[:person])
      js_notify message: t('view.supports.correctly_updated'), type: 'info', time: 2000
      js_redirect reload: true
    else
      #todo: no esta entrando aca, no corre validaciones
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to ['edit', @intervention, @endowment, 'mobile_intervention',
                 @support], alert: t('view.support.stale_object_error')
  end

  def destroy
    @support = Support.find(params[:id])
    @support.destroy
    js_redirect reload: true
  end

  private
  def get_intervention
    @endowment = Endowment.find(params[:endowment_id])
    @intervention = @endowment.intervention
    @mobile_intervention = @endowment.mobile_intervention
  end
end
