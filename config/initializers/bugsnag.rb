if (key = Rails.application.secrets.bugsnag_api_key)
  Bugsnag.configure do |config|
    config.api_key = key
    config.notify_release_stages = %w(production)
    config.ignore_classes = []

    begin
      revision = if Rails.env.production?
                   File.read(Rails.root.join('REVISION')) # Capistrano Revision
                 else
                   `git rev-parse --short HEAD`
                 end

      config.app_version = revision.strip
    rescue
    end
  end
end

