require 'resque/server'

G5ClientAppCreator::Application.routes.draw do
  mount Resque::Server, :at => "/resque"
end
