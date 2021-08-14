# frozen_string_literal: true

# Event
# Has to be in the past
#
# Has to be a data object
#
# Has to have name and data
#
# Can be anything (e.g. hash, structure, etc)
class Event
  attr_reader :payload

  def initialize(payload:)
    @payload = Hash(payload)
  end
end

class ItemAddedToOrder < Event; end

class ItemRemovedFromOrder < Event; end

class OrderCreated < Event; end

class OrderClosed < Event; end

class OrderCheckouted < Event; end
