# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.settlement.Settlement from the Python SDK.
  class Settlement < BaseObject
    attribute :type, :amount

    def type=(value)
      @type = value&.to_s
    end

    def amount=(value)
      @amount = value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end
  end
end
