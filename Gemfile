source "https://rubygems.org"
ruby "2.1.1"

gem "rails", "~> 4.1.0"
gem "jquery-rails"

gem "quiet_assets", "~> 1.0.1"
gem "bootstrap-sass", "~> 2.1.0.1"

gem "heroku_resque_autoscaler", "~> 0.1.0"
gem "github_heroku_deployer", "~> 0.2.1"
gem "microformats2", "2.0.1"
gem "g5_sibling_deployer_engine", "~> 0.4.1"

gem "sass-rails", "~> 4.0.0"
gem "coffee-rails", "~> 4.0.0"
gem "uglifier", ">= 1.0.3"

group :development, :test do
  gem "dotenv-rails", "~> 0.10.0"
  gem "sqlite3"
  gem "simplecov", "~> 0.8.2", require: false
  gem "rspec-rails", "~> 2.14.1"
  gem "guard-rspec", "~> 4.2.8"
  gem "spork"
  gem "rb-fsevent", "~> 0.9.2"
  gem "fabrication", "~> 2.9.8"
  gem "faker", "~> 1.3.0"
  gem "foreman"
end

gem "codeclimate-test-reporter", group: :test, require: nil

group :production do
  gem "unicorn"
  gem "pg"
  gem "newrelic_rpm"
  gem "honeybadger"
  gem "lograge"
  gem "rails_12factor"
end
