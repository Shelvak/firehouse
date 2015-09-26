FROM shelvak/ruby:2.1

MAINTAINER Néstor Coppi <nestorcoppi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get install -qq -y postgresql-server-dev-9.3 \
                           postgresql-client-9.3 imagemagick

RUN mkdir -p /firehouse
RUN mkdir -p /bundle

WORKDIR /firehouse

CMD bundle exec unicorn -c /firehouse/config/unicorn.rb -E production
