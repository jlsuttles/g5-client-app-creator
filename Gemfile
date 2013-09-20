source "https://rubygems.org"
source "https://gems.gemfury.com/***REMOVED***/"
ruby "1.9.3"

gem "rails", "~> 3.2.14"
gem "jquery-rails"

gem "quiet_assets", "~> 1.0.1"
gem "bootstrap-sass", "~> 2.1.0.1"

gem "foreman", "~> 0.60.2"
gem "heroku_resque_autoscaler", "~> 0.1.0"
gem "github_heroku_deployer", "~> 0.2.1"
gem "microformats2", "2.0.0.pre4"
gem "g5_sibling_deployer_engine", "~> 0.2.5"

group :assets do
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

group :development, :test do
  gem "rails-default-database", "~> 1.0.6"
  gem "sqlite3"
  gem "simplecov", "~> 0.7.1", require: false
  gem "rspec-rails", "~> 2.11.4"
  gem "guard-rspec", "~> 2.1.0"
  gem "spork"
  gem "rb-fsevent", "~> 0.9.2"
  gem "fabrication", "~> 2.5.0"
  gem "faker", "~> 1.1.2"
end

gem "codeclimate-test-reporter", group: :test, require: nil

group :production do
  gem "thin", "~> 1.5.0"
  gem "pg"
end
