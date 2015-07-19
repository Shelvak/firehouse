FROM shelvak/ruby:2.1

MAINTAINER Néstor Coppi <nestorcoppi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -qq -y postgresql-server-dev-9.3 nodejs \
                           postgresql-client-9.3 imagemagick

RUN mkdir -p /firehouse
RUN mkdir -p /firehouse/bundler

ENV GEM_HOME /firehouse/bundler
ENV GEM_PATH $GEM_HOME
ENV GEM_ROOT $GEM_HOME
ENV PATH $GEM_HOME/bin:$PATH
RUN gem update --system \
  && gem install bundler \
  && bundle config --global path "$GEM_HOME/" \
  && bundle config --global root "$GEM_HOME/" \
  && bundle config --global bin "$GEM_HOME/bin"

WORKDIR /firehouse

CMD bundle exec unicorn -c /firehouse/config/unicorn.rb -E production
