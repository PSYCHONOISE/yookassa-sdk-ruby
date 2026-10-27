# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.payout.Payout from the Python SDK.
  class Payout
    include YooKassa::ResourceHelpers

    BASE_PATH = '/payouts'

    class << self
      # @param payout_id [String]
      # @return [YooKassa::PayoutResponse]
      def find_one(payout_id)
        raise ArgumentError, 'Invalid payout_id value' if !payout_id.is_a?(String) || payout_id.empty?

        response = client.request(method: YooKassa::HttpVerb::GET, path: "#{BASE_PATH}/#{payout_id}")
        YooKassa::PayoutResponse.new(response)
      end

      # @param params [Hash, YooKassa::PayoutRequest]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::PayoutResponse]
      def create(params, idempotency_key = nil)
        params_object = coerce_params(params, YooKassa::PayoutRequest)
        response = client.request(method: YooKassa::HttpVerb::POST, path: BASE_PATH,
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::PayoutResponse.new(response)
      end
    end
  end
end
