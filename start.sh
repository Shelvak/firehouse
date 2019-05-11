#!/bin/bash

# Bundler y rake ya estan incluidos en la imagen
bundle exec rake assets:precompile
bundle exec rake db:migrate
bundle exec unicorn -c /firehouse/config/unicorn.rb -E production
