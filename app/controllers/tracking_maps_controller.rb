class TrackingMapsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :active_ceo?, only: [:new, :edit]

  check_authorization
  load_and_authorize_resource

  def fullscreen
    @interventions = Intervention.opened
    render layout: false
  end

  private
    def active_ceo?
      @no_active_ceo = Sco.where(current: true).empty?
    end
end
