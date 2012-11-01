source :rubygems
source "https://gems.gemfury.com/#{ENV['GEM_FURY_SECRET']}/"

gem "rails", "3.2.7"
gem "pg"
gem "jquery-rails"
gem "bcrypt-ruby", :require => "bcrypt"
gem 'g5_hentry_consumer'

group :assets do
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :test do
  gem "rb-fsevent"
end

group :development, :test do
  gem "nifty-generators", "~> 0.4.6"
  gem "rspec-rails"
  gem 'guard-rspec'
end

group :production do
  gem "thin", "~> 1.5.0"
end
