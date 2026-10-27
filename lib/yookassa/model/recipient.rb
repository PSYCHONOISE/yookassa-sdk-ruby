# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.recipient.Recipient from the Python SDK.
  class Recipient < BaseObject
    attribute :account_id, :gateway_id
  end
end
