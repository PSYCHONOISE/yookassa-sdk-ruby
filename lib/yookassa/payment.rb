# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.payment.Payment from the Python SDK.
  class Payment
    include YooKassa::ResourceHelpers

    BASE_PATH = '/payments'

    class << self
      # @param payment_id [String]
      # @return [YooKassa::PaymentResponse]
      def find_one(payment_id)
        raise ArgumentError, 'Invalid payment_id value' if !payment_id.is_a?(String) || payment_id.empty?

        response = client.request(method: YooKassa::HttpVerb::GET, path: "#{BASE_PATH}/#{payment_id}")
        YooKassa::PaymentResponse.new(response)
      end

      # @param params [Hash, YooKassa::PaymentRequest]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::PaymentResponse]
      def create(params, idempotency_key = nil)
        params_object = coerce_params(params, YooKassa::PaymentRequest)
        response = client.request(method: YooKassa::HttpVerb::POST, path: BASE_PATH,
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::PaymentResponse.new(response)
      end

      # @param payment_id [String]
      # @param params [Hash, YooKassa::CapturePaymentRequest, nil]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::PaymentResponse]
      def capture(payment_id, params = nil, idempotency_key = nil)
        raise ArgumentError, 'Invalid payment_id value' if !payment_id.is_a?(String) || payment_id.empty?

        params_object =
          if params.nil?
            nil
          else
            coerce_params(params, YooKassa::CapturePaymentRequest)
          end

        response = client.request(method: YooKassa::HttpVerb::POST, path: "#{BASE_PATH}/#{payment_id}/capture",
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::PaymentResponse.new(response)
      end

      # @param payment_id [String]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::PaymentResponse]
      def cancel(payment_id, idempotency_key = nil)
        raise ArgumentError, 'Invalid payment_id value' if !payment_id.is_a?(String) || payment_id.empty?

        response = client.request(method: YooKassa::HttpVerb::POST, path: "#{BASE_PATH}/#{payment_id}/cancel",
                                  headers: idempotence_headers(idempotency_key))
        YooKassa::PaymentResponse.new(response)
      end

      # @param params [Hash, nil] search/filter parameters
      # @return [YooKassa::PaymentListResponse]
      def list(params = nil)
        response = client.request(method: YooKassa::HttpVerb::GET, path: BASE_PATH, query_params: params)
        YooKassa::PaymentListResponse.new(response)
      end
    end
  end
end
