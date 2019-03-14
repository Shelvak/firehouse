class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter -> { expires_now if user_signed_in? }

  helper_method :configs_controller?

  rescue_from Exception do |exception|
    begin
      if exception.kind_of? CanCan::AccessDenied
        redirect_to root_url, alert: t('errors.access_denied')
      else
        ErrorLogger.error(exception)

        @title = t('errors.title')

        if response.redirect_url.blank? && request.format.html?
          render template: 'shared/show_error', locals: { error: exception }
        else
          render json: { error: exception.to_s }
        end
      end

    # In case the rescue explodes itself =)
    rescue => ex
      logger.error(([ex, ''] + ex.backtrace).join("\n"))
    end
  end

  def user_for_paper_trail
    current_user.try(:id)
  end

  # TODO: improve params, implement logger
  before_filter :permit_all!
  def permit_all!
    params.permit!
  end

  def configs_controller?
    # TODO: Find a better way
    controller_path.to_s.match(/configs\//)
  end

  def make_datetime_range(parameters = nil)
    if parameters
      from_datetime = Timeliness::Parser.parse(
        parameters[:from], :datetime, zone: :local
      )
      to_datetime = Timeliness::Parser.parse(
        parameters[:to], :datetime, zone: :local
      )
    end
    from_datetime ||= Time.zone.now.at_beginning_of_day
    to_datetime ||= Time.zone.now

    [from_datetime.to_datetime, to_datetime.to_datetime].sort
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    new_intervention_path
  end
end
