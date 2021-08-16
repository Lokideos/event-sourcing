# frozen_string_literal: true

module Producers
  class AddItem
    def initialize
      @project = Projections::Project.new
    end

    # We expect to get events from event stream
    # payload:
    #   account_id
    #   name
    #   cost
    #
    def call(events, payload)
      state = @project.call(Projections::AllOrders.new, {}, events)
      order_for_account = state[:orders]&.first

      if order_for_account
        [
          Events::ItemAddedToOrder.new(
            payload: {
              order_id: order_for_account[:order_id],
              item_id: SecureRandom.uuid,
              name: payload[:name],
              cost: payload[:cost]
            }
          )
        ]
      else
        order_id = SecureRandom.uuid
        [
          Events::OrderCreated.new(
            payload: { order_id: order_id, account_id: payload[:account_id] }
          ),
          Events::ItemAddedToOrder.new(
            payload: {
              order_id: order_id,
              item_id: SecureRandom.uuid,
              name: payload[:name],
              cost: payload[:cost]
            }
          )
        ]
      end
    end
  end
end
