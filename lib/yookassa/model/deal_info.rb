# frozen_string_literal: true

module YooKassa
  # Mirrors PaymentDealInfo from yookassa.domain.models.deal (Python SDK).
  # The `deal` sub-object attached to a payment.
  class PaymentDealInfo < BaseObject
    attribute :id, :settlements

    def settlements=(value)
      @settlements = Array(value).map { |item| item.is_a?(Settlement) ? item : Settlement.new(item) }
    end
  end

  # Mirrors PayoutDealInfo from yookassa.domain.models.deal (Python SDK).
  # The `deal` sub-object attached to a payout.
  class PayoutDealInfo < BaseObject
    attribute :id
  end

  # Mirrors RefundDealInfo from yookassa.domain.models.deal (Python SDK).
  # The `deal` sub-object attached to a refund response.
  class RefundDealInfo < BaseObject
    attribute :id, :refund_settlements

    def refund_settlements=(value)
      @refund_settlements = Array(value).map { |item| item.is_a?(Settlement) ? item : Settlement.new(item) }
    end
  end

  # Mirrors RefundDealData from yookassa.domain.models.deal (Python SDK).
  # The `deal` parameter sent when creating a refund.
  class RefundDealData < BaseObject
    attribute :refund_settlements

    def refund_settlements=(value)
      @refund_settlements = Array(value).map { |item| item.is_a?(Settlement) ? item : Settlement.new(item) }
    end
  end
end
