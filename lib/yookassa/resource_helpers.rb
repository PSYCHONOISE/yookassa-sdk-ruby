# frozen_string_literal: true

require 'securerandom'

module YooKassa
  # Shared helpers used by the top-level resource classes
  # (Payment, Refund, Receipt, Payout, Deal, Webhook, Settings), which mirror
  # yookassa.payment.Payment and friends from the Python SDK.
  module ResourceHelpers
    module ClassMethods
      def client
        YooKassa::ApiClient.new
      end

      # Dispatches `params` the way the Python SDK does: a Hash is wrapped
      # into `request_class`, an already-built instance of `request_class` is
      # used as-is, and anything else raises TypeError.
      def coerce_params(params, request_class)
        case params
        when Hash then request_class.new(params)
        else
          return params if params.is_a?(request_class)

          raise TypeError, 'Invalid params value type'
        end
      end

      def idempotence_headers(idempotency_key)
        { 'Idempotence-Key' => (idempotency_key || SecureRandom.uuid).to_s }
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
