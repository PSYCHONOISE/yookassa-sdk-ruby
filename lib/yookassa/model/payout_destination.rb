# frozen_string_literal: true

module YooKassa
  # Generic payout destination data object (bank_card / yoo_money_wallet).
  #
  # Mirrors yookassa.domain.models.payout_data.payout_destination.PayoutDestination
  # from the Python SDK, merging the per-type request/response classes into
  # one flexible class driven by `type`, with pass-through attributes for
  # the rest (e.g. `card`, `account_number`).
  class PayoutDestination < BaseObject
    attribute :type

    def type=(value)
      @type = value&.to_s
    end
  end
end
