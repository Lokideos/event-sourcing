# frozen_string_literal: true

# projection
#   pure function
#
#   project(projection, initial_state, event_list) -> state
#   project(projection, state, event_list) -> new_state
module Projections
  class Project
    def call(projection, initial_state, events)
      events.reduce(initial_state) do |state, event|
        projection.call(state, event)
      end
    end
  end

  class AllOrders
    def call(state, event)
      case event
      when Events::OrderCreated
        state[:orders] ||= []
        state[:orders] << { **event.payload, items: [] }
      when Events::ItemAddedToOrder
        order = state[:orders].select { |chosen_order| chosen_order[:order_id] == event.payload[:order_id] }.first
        state[:orders].delete_if { |chosen_order| chosen_order[:order_id] == event.payload[:order_id] }.first

        order[:items] << event.payload

        state[:orders] << order
      end

      state
    end
  end

  class CostForOrders
    def call(state, event)
      case event
      when Events::OrderCreated
        state[:order_costs] ||= {}
        state[:order_costs][event.payload[:order_id]] = 0
      when Events::ItemAddedToOrder
        state[:order_costs][event.payload[:order_id]] += event.payload[:cost]
      end

      state
    end
  end
end
