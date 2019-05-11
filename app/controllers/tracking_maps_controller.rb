class TrackingMapsController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  def fullscreen
    @interventions = Intervention.opened
    render layout: false
  end

  private
end
