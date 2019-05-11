#!/bin/bash

# Bundler y rake ya estan incluidos en la imagen
bundle install --jobs 8
bundle exec rake db:migrate
bundle exec rake assets:precompile
bundle exec unicorn -c /firehouse/config/unicorn.rb -E production
