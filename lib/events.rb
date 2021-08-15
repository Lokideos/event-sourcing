# frozen_string_literal: true

module Events
  # Event
  # Has to be in the past
  #
  # Has to be a data object
  #
  # Has to have name and data
  #
  # Can be anything (e.g. hash, structure, etc)
  class Base
    attr_reader :payload

    def initialize(payload:)
      @payload = Hash(payload)
    end
  end

  class ItemAddedToOrder < Base; end

  class ItemRemovedFromOrder < Base; end

  class OrderCreated < Base; end

  class OrderClosed < Base; end

  class OrderCheckouted < Base; end
end
