# frozen_string_literal: true

require_relative './events'
require_relative './event_store'
require_relative './projections'

class Main; end

puts 'Initial state:'
event_store = EventStore.new
project = Projections::Project.new

puts '*' * 50

puts 'After creating order:'
event = Events::OrderCreated.new(payload: { order_id: 1, account_id: 1 })
event_store.append(event)

p events = event_store.get
pp project.call(Projections::AllOrders.new, {}, events)

puts '*' * 50

puts 'After creating one more order:'
event = Events::OrderCreated.new(payload: { order_id: 2, account_id: 1 })
event_store.append(event)
pp project.call(Projections::AllOrders.new, {}, events)

puts '*' * 50

puts 'After adding items to orders:'
event = Events::ItemAddedToOrder.new(payload: { order_id: 1, item_id: 1, name: 'ruby sticker', cost: 10 })
event_store.append(event)

event = Events::ItemAddedToOrder.new(payload: { order_id: 1, item_id: 2, name: 'git sticker', cost: 17 })
event_store.append(event)

event = Events::ItemAddedToOrder.new(payload: { order_id: 2, item_id: 3, name: 'ruby sticker', cost: 11 })
event_store.append(event)

pp project.call(Projections::AllOrders.new, {}, events)

puts '*' * 50

puts 'Calculation cost for orders:'
pp project.call(Projections::CostForOrders.new, {}, events)
