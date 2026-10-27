# frozen_string_literal: true

require 'bigdecimal'

module YooKassa
  # Represents a sum of money: value + currency.
  #
  # Mirrors yookassa.domain.models.amount.Amount from the Python SDK.
  class Amount < BaseObject
    attribute :value, :currency

    def value=(value)
      @value = BigDecimal(value.to_s).round(2, BigDecimal::ROUND_HALF_UP)
    end

    def currency=(value)
      @currency = value&.to_s
    end

    # Amount values are always rendered with exactly 2 decimal digits
    # (e.g. "10.00", not "10.0"), matching the YooKassa API.
    def to_h
      hash = super
      hash[:value] = format('%.2f', value) if hash.key?(:value)
      hash
    end
  end
end
