# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.receipt.Receipt from the Python SDK.
  #
  # Note: this is the Receipts API resource (create/find/list standalone
  # receipts). The `receipt` sub-object embedded in a payment/refund request
  # is YooKassa::ReceiptData.
  class Receipt
    include YooKassa::ResourceHelpers

    BASE_PATH = '/receipts'

    class << self
      # @param receipt_id [String]
      # @return [YooKassa::ReceiptResponse]
      def find_one(receipt_id)
        raise ArgumentError, 'Invalid receipt_id value' if !receipt_id.is_a?(String) || receipt_id.empty?

        response = client.request(method: YooKassa::HttpVerb::GET, path: "#{BASE_PATH}/#{receipt_id}")
        YooKassa::ReceiptResponse.new(response)
      end

      # @param params [Hash, YooKassa::ReceiptRequest]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::ReceiptResponse]
      def create(params, idempotency_key = nil)
        params_object = coerce_params(params, YooKassa::ReceiptRequest)
        response = client.request(method: YooKassa::HttpVerb::POST, path: BASE_PATH,
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::ReceiptResponse.new(response)
      end

      # @param params [Hash, nil] search/filter parameters
      # @return [YooKassa::ReceiptListResponse]
      def list(params = nil)
        response = client.request(method: YooKassa::HttpVerb::GET, path: BASE_PATH, query_params: params)
        YooKassa::ReceiptListResponse.new(response)
      end
    end
  end
end
