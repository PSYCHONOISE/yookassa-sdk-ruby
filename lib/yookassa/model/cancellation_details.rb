# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.cancellation_details.CancellationDetails
  # from the Python SDK.
  class CancellationDetails < BaseObject
    attribute :party, :reason
  end
end
