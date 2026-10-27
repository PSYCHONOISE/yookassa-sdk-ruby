# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.authorization_details.AuthorizationDetails
  # from the Python SDK.
  class AuthorizationDetails < BaseObject
    attribute :rrn, :auth_code, :three_d_secure

    def three_d_secure=(value)
      @three_d_secure = value.nil? || value.is_a?(ThreeDSecure) ? value : ThreeDSecure.new(value)
    end

    # Mirrors the nested ThreeDSecure class from authorization_details.py
    class ThreeDSecure < BaseObject
      attribute :applied
    end
  end
end
