module RedisUtils
	def redis
		@redis_client ||= Redis.new
  end

	def redis_local_key(instance)
    "#{instance.class.to_s.underscore}_last_local_sync"
  end

	def redis_remote_key(instance)
    "#{instance.class.to_s.underscore}_last_remote_sync"
  end

  def fetch_last_local_sync(instance)
    last_sync_date_time = Maybe(redis.get(redis_local_key(instance))).fetch(100.years.ago.to_s)
    DateTime.parse(last_sync_date_time)
  end

	def set_last_local_sync(instance, datetime)
		redis.set(redis_local_key(instance), datetime)
	end

	def fetch_last_remote_sync(instance)
    last_sync_date_time = Maybe(redis.get(redis_remote_key(instance))).fetch(100.years.ago.to_s)
    DateTime.parse(last_sync_date_time)
  end

	def set_last_remote_sync(instance, datetime)
		redis.set(redis_remote_key(instance), datetime)
	end
end
