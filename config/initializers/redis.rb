class FakeRedis
  def method_missing(sym, *args, &block)
    puts "Cant connect to redis"
    true
  end
end

$redis = Redis.new(host: APP_CONFIG[:redis][:host])

begin
  $redis.ping
rescue
  $redis = FakeRedis.new
end
