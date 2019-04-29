class FakeRedis
  def method_missing(sym, *args, &block)
    puts "Cant connect to redis"
    true
  end
end
