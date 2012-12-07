require 'resque/server'

G5ClientAppCreator::Application.routes.draw do
  mount Resque::Server, :at => "/resque"

  resources :client_apps, only: [:index]

  post "webhooks/g5-configurator" => "webhooks#g5_configurator"
  root to: "client_apps#index"
end
