class WebsocketsController < ApplicationController
  require 'timeout'
  include ActionController::Live

  def console
    response.headers['Content-Type'] = 'text/event-stream'
    @sse = SSE.new(response.stream, retry: 300, event: 'console')
    @redis = Redis.new

    Timeout::timeout(30) do
      @redis.subscribe('console') do |on|
        on.message do |channel, msg|
          @sse.write({ link: msg })
        end
      end
    end
  ensure
    @sse.close
  end
end
