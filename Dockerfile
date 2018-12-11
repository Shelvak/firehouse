FROM ruby:2.5-alpine

MAINTAINER Néstor Coppi <nestorcoppi@gmail.com>

RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc \
    && apk --update add --virtual build-dependencies build-base gcc postgresql-dev \
    && apk --update add libpq bash nodejs libxml2 libxml2-dev libxml2-utils libxslt libxslt-dev zlib tzdata git imagemagick \
    && gem install bundler
# libxml2-dev

RUN git clone --depth 1 https://github.com/Shelvak/firehouse /firehouse

WORKDIR /firehouse

# RUN bundle config build.nokogiri --use-system-libraries && \
RUN bundle install --deployment --jobs 4 && \
    apk del build-dependencies

CMD bundle exec unicorn -c /firehouse/config/unicorn.rb -E production
