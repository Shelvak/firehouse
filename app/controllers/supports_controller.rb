class SupportsController < ApplicationController
  before_filter :get_intervention
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

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
    if @support.save
      js_notify message: t('view.supports.correctly_created'),
                type: 'alert-info js-notify-18px-text', time: 2500
      render partial: 'mobile_interventions/support', locals: { support: @support},
             content_type: 'text/html'
    else
      render partial: 'new', status: :unprocessable_entity
    end
  end

  def update
    @title = t('view.supports.modal.involved_support')
    @support = Support.find(params[:id])

    if @support.update_attributes(params[:support])

      js_notify message: t('view.supports.correctly_updated'),
                type: 'alert-info js-notify-18px-text', time: 2500
      render partial: 'mobile_interventions/support', locals: { support: @support},
             content_type: 'text/html'
    else
      render partial: 'edit', status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to [
      'edit', @intervention, @endowment, 'mobile_intervention', @support
    ], alert: t('view.support.stale_object_error')
  end

  def destroy
    @support = Support.find(params[:id])
    @support.destroy

    js_notify message: t('view.supports.correctly_destroyed'),
              type: 'alert-danger js-notify-18px-text', time: 2500
    render nothing: true, content_type: 'text/html'
  end

  private
    def get_intervention
      @endowment = Endowment.find(params[:endowment_id])
      @intervention = @endowment.intervention
      @mobile_intervention = @endowment.mobile_intervention
    end
end
