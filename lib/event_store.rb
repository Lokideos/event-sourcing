# frozen_string_literal: true

# Event store
#   immutable
# Class interface:
#   get(nil -> list of events)
#   append(list of events -> nil)

class EventStore
  def initialize
    @store = []
  end

  def get
    @store
  end

  def append(*events)
    events.each { |event| @store << event }
  end

  def evolve(producer, payload)
    new_events = producer.call(@store, payload)
    @store += new_events
  end
end
