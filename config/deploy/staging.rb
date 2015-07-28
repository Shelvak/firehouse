set :stage, :staging
set :rails_env, 'production'

set :chruby_ruby, '2.1.3'
role :web, %w{192.168.0.103}
role :app, %w{192.168.0.103}
role :db,  %w{192.168.0.103}

server '192.168.0.103', user: 'webmaster', roles: %w{web app db}
