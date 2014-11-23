set :stage, :production
set :rails_env, 'production'
set :ssh_options, { port: 5611 }

set :chruby_ruby, '2.0.0-p576'
role :web, %w{bvgc.no-ip.org}
role :app, %w{bvgc.no-ip.org}
role :db,  %w{bvgc.no-ip.org}

server 'bvgc.no-ip.org', user: 'webmaster', roles: %w{web app db}
