Rails.application.configure do
  config.action_mailer.default_url_options = { host: APP_CONFIG['public_host'] }
  config.action_mailer.smtp_settings = SECRETS['email'].symbolize_keys
end
