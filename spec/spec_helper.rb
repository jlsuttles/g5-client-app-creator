require 'rubygems'
require 'spork'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  end

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
  end

  Spork.trap_method(Rails::Application, :eager_load!)
  require File.expand_path("../../config/environment", __FILE__)
  Rails.application.railties.all { |r| r.eager_load! }
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  end
end
