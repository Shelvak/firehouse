FROM ruby:2.3-alpine

MAINTAINER Néstor Coppi <nestorcoppi@gmail.com>

RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc \
    && apk --update add --virtual build-dependencies build-base gcc postgresql-dev linux-headers libxml2 libxml2-dev libxml2-utils libxslt libxslt-dev \
    && apk --update add libpq bash nodejs zlib tzdata git imagemagick \
    && gem install bundler

RUN git clone --depth 1 https://github.com/Shelvak/firehouse /firehouse

WORKDIR /firehouse

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --deployment --jobs 4 && \
    apk del build-dependencies

RUN cp config/app_config.example.yml config/app_config.yml \
    && mkdir -p /firehouse/tmp \
    && bundle exec rake assets:precompile

CMD /firehouse/start.sh
