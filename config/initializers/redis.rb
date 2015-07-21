module ReadCache
  class << self
    def redis
      @redis ||= Redis.new(:url => "redis://#{ENV['REDIS_URL'] || '127.0.0.1:6379'}")
    end
  end
end
