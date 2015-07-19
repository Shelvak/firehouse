#!/bin/bash

psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -U postgres \
    -c "CREATE ROLE firehouse WITH SUPERUSER \
     CREATEDB CREATEROLE LOGIN ENCRYPTED \
     PASSWORD 'firehouse' NOINHERIT VALID UNTIL 'infinity';"

export RAILS_ENV=production
cd /firehouse

gem update --system && gem install bundler
bundle install --without development
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake assets:clean assets:precompile
bundle exec rake db:seed
