module RedisClient
  def self.client
    # Redis.new(host: APP_CONFIG[:redis][:host])
    Redis.new
  end

  def method_missing(m, *args, &block)
    self.class.client.send(m, *args, &block)
  end

  def self.method_missing(m, *args, &block)
    self.client.send(m, *args, &block)
  end
end
