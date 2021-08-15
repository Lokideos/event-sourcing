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
end
