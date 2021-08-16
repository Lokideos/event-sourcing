# frozen_string_literal: true

# Event store
#   immutable
# Class interface:
#   get(nil -> list of events)
#   append(list of events -> nil)

class EventStore
  # store => { stream => [...] of events }
  def initialize
    @store = {}
  end

  def get
    @store.flat_map { |_stream, events| events }
  end

  def get_stream(stream)
    @store[stream] || {}
  end

  def append(stream, *events)
    @store[stream] ||= []

    events.each { |event| @store[stream] << event }
  end

  def evolve(stream, producer, payload)
    events = get_stream(stream)
    new_events = producer.call(events, payload)
    @store[stream] = (@store[stream] || []) + new_events
  end
end
