FROM shelvak/ruby:2.1

MAINTAINER Néstor Coppi <nestorcoppi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN git clone https://github.com/FRM-UTN/firehouse

WORKDIR firehouse

ADD /shared/firehouse.app_config.yml config/app_config.yml

ENV RAILS_ENV production

RUN bundle install --without development test --deployment --quiet
RUN bundle exec rake db:migrate
RUN bundle exec rake assets:precompile

VOLUME ["/shared", "/tmp"]

RUN ln -sf $(pwd) /shared/firehouse

CMD bundle exec unicorn -E production -c config/unicorn.rb
