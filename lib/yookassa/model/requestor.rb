# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.requestor.Requestor and subclasses from the
  # Python SDK. Deprecated upstream; kept here only for completeness.
  class Requestor < BaseObject
    attribute :type
  end

  # Mirrors RequestorMerchant from the Python SDK.
  class RequestorMerchant < Requestor
    attribute :account_id

    def initialize(attributes = nil)
      super(attributes)
      self.type ||= 'merchant'
    end
  end

  # Mirrors RequestorThirdPartyClient from the Python SDK.
  class RequestorThirdPartyClient < Requestor
    attribute :client_id, :client_name

    def initialize(attributes = nil)
      super(attributes)
      self.type ||= 'third_party_client'
    end
  end
end
