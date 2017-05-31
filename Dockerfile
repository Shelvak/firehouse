FROM shelvak/ruby

MAINTAINER Néstor Coppi <nestorcoppi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y postgresql-server-dev-9.5 \
                           postgresql-client-9.5 imagemagick
RUN apt-get -y clean autoclean autoremove


RUN gem install bundler
RUN git clone --depth 1 https://github.com/Shelvak/firehouse

WORKDIR /firehouse

RUN bundle install

CMD bundle exec unicorn -c /firehouse/config/unicorn.rb -E production
