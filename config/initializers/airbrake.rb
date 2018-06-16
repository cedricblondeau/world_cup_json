
Airbrake.configure do |c|
  config.host = 'http://errbit.softwareforgood.com'
  c.project_id = true
  c.project_key = ENV['AIRBRAKE_KEY']
  c.root_directory = Rails.root
  c.logger = Rails.logger
  c.environment = Rails.env
  c.ignore_environments = %w(test development staging)
  c.blacklist_keys = [/password/i, /authorization/i]
end

Airbrake.add_filter(Airbrake::Rack::RequestBodyFilter.new)
Airbrake.add_filter(Airbrake::Filters::ThreadFilter.new)
