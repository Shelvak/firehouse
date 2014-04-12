set :stage, :production
set :rails_env, 'production'

role :web, %w{bomberos-godoycruz.no-ip.org}
role :app, %w{bomberos-godoycruz.no-ip.org}
role :db,  %w{bomberos-godoycruz.no-ip.org}

server 'bomberos-godoycruz.no-ip.org', user: 'deployer', roles: %w{web app db}
