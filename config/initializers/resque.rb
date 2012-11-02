# Setup for Heroku
Resque.redis = ENV["REDISTOGO_URL"] if ENV["REDISTOGO_URL"]

# Establish connection to the database before each job
Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }

# Require HTTP Basic Auth to view dashboard
if ENV["NERD_HTTP_USER"] && ENV["NERD_HTTP_PASSWORD"]
  Resque::Server.use(Rack::Auth::Basic) do |user, password|
    user == ENV["NERD_HTTP_USER"] and password == ENV["NERD_HTTP_PASSWORD"]
  end
end
