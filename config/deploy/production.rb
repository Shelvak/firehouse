set :stage, :production
set :rails_env, 'production'
set :ssh_options, { port: 5611 }

set :chruby_ruby, '2.0.0-p576'
role :web, %w{bomberos}
role :app, %w{bomberos}
role :db,  %w{bomberos}

server 'bomberos', user: 'webmaster', roles: %w{web app db}
