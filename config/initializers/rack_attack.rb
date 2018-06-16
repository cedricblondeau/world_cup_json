if ENV['REDISTOGO_URL']
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(ENV['REDISTOGO_URL'], { expires_in: 480.minutes })
end

Rack::Attack.throttle('requests by ip', limit: 5, period: 2, &:ip)

Rack::Attack.throttled_response = lambda do |env|
  now = Time.now
  match_data = env['rack.attack.match_data']

  headers = {
    'X-RateLimit-Limit' => match_data[:limit].to_s,
    'X-RateLimit-Remaining' => '0',
    'X-RateLimit-Reset' => (now + (match_data[:period] - now.to_i % match_data[:period])).to_s
  }

  [429, headers, ["Throttled\n"]]
end