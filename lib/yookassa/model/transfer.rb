# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.transfer.Transfer and
  # yookassa.domain.response.transfer_response.TransferResponse from the
  # Python SDK (merged into one class; `status` is only present on responses).
  class Transfer < BaseObject
    attribute :account_id, :amount, :platform_fee_amount, :status, :metadata

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def platform_fee_amount=(value)
      @platform_fee_amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end
  end

  # Alias kept for parity with the Python SDK's TransferResponse name. It is
  # the exact same structure as YooKassa::Transfer.
  TransferResponse = Transfer
end
