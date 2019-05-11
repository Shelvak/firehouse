config_path = File.join(
  Rails.root,
  'config',
  (ENV['HEROKU'] ? 'app_config.example.yml' : 'app_config.yml')
)

APP_CONFIG = {
  public_host: ENV['SERVER_HOST']
}.with_indifferent_access

if ENV['HEROKU']
  require 'fileutils'
  FileUtils.cp(Rails.root.join('config/secrets.example.yml'), Rails.root.join('config/secrets.yml'))
end

if ENV['HEROKU']
  require 'fileutils'
  FileUtils.cp(Rails.root.join('config/secrets.example.yml'), Rails.root.join('config/secrets.yml'))
end

SECRETS = Rails.application.secrets
          .deep_symbolize_keys
          .with_indifferent_access
