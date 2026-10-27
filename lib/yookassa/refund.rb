# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.refund.Refund from the Python SDK.
  class Refund
    include YooKassa::ResourceHelpers

    BASE_PATH = '/refunds'

    class << self
      # @param params [Hash, YooKassa::RefundRequest]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::RefundResponse]
      def create(params, idempotency_key = nil)
        params_object = coerce_params(params, YooKassa::RefundRequest)
        response = client.request(method: YooKassa::HttpVerb::POST, path: BASE_PATH,
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::RefundResponse.new(response)
      end

      # @param refund_id [String]
      # @return [YooKassa::RefundResponse]
      def find_one(refund_id)
        raise ArgumentError, 'Invalid refund_id value' if !refund_id.is_a?(String) || refund_id.empty?

        response = client.request(method: YooKassa::HttpVerb::GET, path: "#{BASE_PATH}/#{refund_id}")
        YooKassa::RefundResponse.new(response)
      end

      # @param params [Hash, nil] search/filter parameters
      # @return [YooKassa::RefundListResponse]
      def list(params = nil)
        response = client.request(method: YooKassa::HttpVerb::GET, path: BASE_PATH, query_params: params)
        YooKassa::RefundListResponse.new(response)
      end
    end
  end
end
