require 'resque/server'

G5ClientAppCreator::Application.routes.draw do
  mount Resque::Server, :at => "/resque"

  resources :client_apps, only: [:index]

  post "consume_feed" => "webhooks#consume_feed"
  root to: "client_apps#index"
end
