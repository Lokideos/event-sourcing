# Event Sourcing

This is example project for trying out event sourcing in Ruby  
The project is inspired by [Anton Davidov Event Sourcing project](https://github.com/2pegramming/pepegraming-stream/tree/master/event_sourcing)

Gems for working with event sourcing:
* [Rails Event Store](https://railseventstore.org/)
* [Ruby Event Sourcing library](https://github.com/davydovanton/ivento)

### Event sourcing
* work with events
* no state (e.g. no DB tables)
* get event and store it

### Event-driven architecture
* work with events
* get event and handle it or say about it
* state is present  (e.g. DB)

## Event sourcing main conceptions
* event - any event happened, which happened in the past
* event store - place for storing events
* projection - abstraction, which compose state from the events
* producer - abstraction, which creates (produces) the events

## Oversimplified event sourcing example
```
event_store = []
event_store << { name: 'add item', payload: { cost: 4, order_id: 1 } }
event_store << { name: 'add item', payload: { cost: 10, order_id: 1 } }
event_store << { name: 'add item', payload: { cost: 7, order_id: 1 } }
event_store << { name: 'add item', payload: { cost: 11, order_id: 2 } }

pp event_store # => list of events

order_total_cost = 0 # initial_state

event_store.each do |event|
  if event.dig(:payload, :order_id) == 1
    order_total_cost += event.dig(:payload, :cost)
  end
end

puts "Total cost of order #1 : #{order_total_cost}"

event_store << { name: 'add item', payload: { cost: -3, order_id: 1 } }

order_total_cost = 0 # initial_state

event_store.each do |event|
  if event.dig(:payload, :order_id) == 1
    order_total_cost += event.dig(:payload, :cost)
  end
end

puts "Total cost of order #1 : #{order_total_cost}"

order_items_total_count = 0 # initial state

event_store.each do |event|
  if event[:name] == 'add item' && event.dig(:payload, :order_id) == 1
    order_items_total_count += 1
  end
end

puts "Order #1 has #{order_items_total_count} items"

```
