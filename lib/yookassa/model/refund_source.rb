# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.refund_source.RefundSource from the Python SDK.
  class RefundSource < BaseObject
    attribute :account_id, :amount, :platform_fee_amount

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def platform_fee_amount=(value)
      @platform_fee_amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end
  end
end
