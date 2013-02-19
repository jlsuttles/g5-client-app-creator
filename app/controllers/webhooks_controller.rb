class WebhooksController < ApplicationController
  def g5_configurator
    Entry.async_consume_feed
    Sibling::Instruction.async_consume_feed
    render json: {}, status: :ok
  end
end
