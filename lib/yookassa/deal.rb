# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.deal.Deal from the Python SDK.
  class Deal
    include YooKassa::ResourceHelpers

    BASE_PATH = '/deals'

    class << self
      # @param deal_id [String]
      # @return [YooKassa::DealResponse]
      def find_one(deal_id)
        raise ArgumentError, 'Invalid deal_id value' if !deal_id.is_a?(String) || deal_id.empty?

        response = client.request(method: YooKassa::HttpVerb::GET, path: "#{BASE_PATH}/#{deal_id}")
        YooKassa::DealResponse.new(response)
      end

      # @param params [Hash, YooKassa::DealRequest]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::DealResponse]
      def create(params, idempotency_key = nil)
        params_object = coerce_params(params, YooKassa::DealRequest)
        response = client.request(method: YooKassa::HttpVerb::POST, path: BASE_PATH,
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::DealResponse.new(response)
      end

      # @param params [Hash, nil] search/filter parameters
      # @return [YooKassa::DealListResponse]
      def list(params = nil)
        response = client.request(method: YooKassa::HttpVerb::GET, path: BASE_PATH, query_params: params)
        YooKassa::DealListResponse.new(response)
      end
    end
  end
end
