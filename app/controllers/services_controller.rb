class ServicesController < ApplicationController
  def tanga
    threads = []
    @tanga = {}
    %w[audio].each do |serv|
      threads << Thread.new do
        RedisClient.receive_in_random_channel do |msg|
          @tanga[serv] = msg
        end
      end
      RedisClient.publish("services-test:#{serv}", { channel: channel, message: 'ping' })
    end
    AudioPlayer::Helpers.redis.publish('services-test:audio', { channel: 'tanga', message: 'ping'}.to_json )
  end
end
