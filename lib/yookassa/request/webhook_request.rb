# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.webhook_request.WebhookRequest from the
  # Python SDK.
  class WebhookRequest < BaseObject
    attribute :event, :url

    def event=(value)
      @event = value&.to_s
    end

    def url=(value)
      @url = value&.to_s
    end
  end
end
