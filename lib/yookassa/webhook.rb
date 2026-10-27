# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.webhook.Webhook from the Python SDK.
  class Webhook
    include YooKassa::ResourceHelpers

    BASE_PATH = '/webhooks'

    class << self
      # @return [YooKassa::WebhookList]
      def list
        response = client.request(method: YooKassa::HttpVerb::GET, path: BASE_PATH)
        YooKassa::WebhookList.new(response)
      end

      # @param params [Hash, YooKassa::WebhookRequest]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::WebhookResponse]
      def add(params, idempotency_key = nil)
        params_object = coerce_params(params, YooKassa::WebhookRequest)
        response = client.request(method: YooKassa::HttpVerb::POST, path: BASE_PATH,
                                  headers: idempotence_headers(idempotency_key), body: params_object)
        YooKassa::WebhookResponse.new(response)
      end

      # @param webhook_id [String]
      # @param idempotency_key [String, nil]
      # @return [YooKassa::WebhookResponse]
      def remove(webhook_id, idempotency_key = nil)
        response = client.request(method: YooKassa::HttpVerb::DELETE, path: "#{BASE_PATH}/#{webhook_id}",
                                  headers: idempotence_headers(idempotency_key))
        YooKassa::WebhookResponse.new(response)
      end
    end
  end
end
