# frozen_string_literal: true

require 'securerandom'
require_relative './events'
require_relative './event_store'
require_relative './projections'
require_relative './producers'

class Main; end

event_store = EventStore.new
project = Projections::Project.new

events = event_store.get
pp project.call(Projections::AllOrders.new, {}, events)

puts '*' * 80

event = Events::OrderCreated.new(payload: { order_id: SecureRandom.uuid, account_id: 1 })
event_store.append(event)

event_store.evolve(Producers::AddItem.new, account_id: 1, name: 'ruby sticker', cost: 10)

event_store.evolve(Producers::AddItem.new, account_id: 2, name: 'hanami sticker', cost: 5)
event_store.evolve(Producers::AddItem.new, account_id: 2, name: 'ruby sticker', cost: 15)

events = event_store.get
pp project.call(Projections::AllOrders.new, {}, events)
