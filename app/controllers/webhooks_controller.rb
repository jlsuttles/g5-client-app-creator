class WebhooksController < ApplicationController
  def consume_feed
    Entry.async_consume_feed
    render json: {}, status: :ok
  end
end
