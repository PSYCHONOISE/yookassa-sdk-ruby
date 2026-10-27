# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.response.webhook_response.WebhookResponse from
  # the Python SDK.
  class WebhookResponse < BaseObject
    attribute :id, :event, :url
  end

  # Mirrors yookassa.domain.response.webhook_response.WebhookList from the
  # Python SDK.
  class WebhookList < BaseObject
    attribute :type, :items

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::WebhookResponse) ? item : YooKassa::WebhookResponse.new(item) }
    end
  end
end
