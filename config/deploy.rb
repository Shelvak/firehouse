set :application, 'firehouse'
set :user, 'webmaster'
set :repo_url, 'https://github.com/FRM-UTN/firehouse.git'

set :scm, :git
set :deploy_to, '/var/firehouse'
set :deploy_via, :remote_cache

set :format, :pretty
set :log_level, :debug

set :linked_files, %w{config/app_config.yml}
set :linked_dirs, %w{log uploads}

set :keep_releases, 5

set :chruby_ruby, '2.0.0-p576'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app) do
      execute :mkdir, '-p', "#{current_path}/tmp/pids"
      execute :ln, '-nfs',
        "#{shared_path}/uploads",
        "#{current_path}/public/uploads"
    end
  end
end
