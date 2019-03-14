module RedisClient
  def self.client
    Redis.new(SECRETS[:redis])
  end

  def method_missing(m, *args, &block)
    self.class.client.send(m, *args, &block)
  end

  def self.method_missing(m, *args, &block)
    self.client.send(m, *args, &block)
  end

  def self.socketio_emit(emit, data = {})
    publish(
      'socketio-rails-notifier',
      {
        emit: emit,
        data: data || {}
      }.to_json
    )
  end
end
