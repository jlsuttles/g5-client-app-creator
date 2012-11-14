require 'resque/server'

G5ClientAppCreator::Application.routes.draw do
  mount Resque::Server, :at => "/resque"

  resources :client_apps, only: [:index]

  root to: "client_apps#index"
end
