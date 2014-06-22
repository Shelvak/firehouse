set :application, 'firehouse'
set :user, 'deployer'
set :repo_url, 'https://github.com/FRM-UTN/firehouse.git'

set :scm, :git
set :deploy_to, '/var/rails/firehouse'
set :deploy_via, :remote_cache

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/app_config.yml}
set :linked_dirs, %w{log private public/uploads}

set :keep_releases, 5
