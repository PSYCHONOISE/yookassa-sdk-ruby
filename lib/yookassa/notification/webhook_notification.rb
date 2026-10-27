# frozen_string_literal: true

module YooKassa
  # Parses an incoming webhook payload (`{"type", "event", "object"}`) into a
  # typed notification whose #object is the matching response type
  # (PaymentResponse / RefundResponse / PayoutResponse / DealResponse).
  #
  # Mirrors yookassa.domain.notification.webhook_notification.WebhookNotification
  # and WebhookNotificationFactory from the Python SDK.
  class WebhookNotification < BaseObject
    attribute :type, :event, :object

    # @param attributes [Hash] the raw webhook payload, with string or symbol keys.
    def self.build(attributes)
      new(attributes)
    end

    def object=(value)
      raise ArgumentError, 'Parameter object is empty' if value.nil? || (value.respond_to?(:empty?) && value.empty?)
      raise TypeError, 'Invalid object type' unless value.is_a?(Hash) || value.is_a?(BaseObject)

      @object = value.is_a?(BaseObject) ? value : response_class.new(value)
    end

    private

    def response_class
      case event
      when YooKassa::WebhookNotificationEventType::REFUND_SUCCEEDED
        YooKassa::RefundResponse
      when YooKassa::WebhookNotificationEventType::DEAL_CLOSED
        YooKassa::DealResponse
      when YooKassa::WebhookNotificationEventType::PAYOUT_SUCCEEDED, YooKassa::WebhookNotificationEventType::PAYOUT_CANCELED
        YooKassa::PayoutResponse
      else
        YooKassa::PaymentResponse
      end
    end
  end

  # Factory that inspects `type`/`event` and builds the right notification.
  # Since YooKassa::WebhookNotification already dispatches #object based on
  # #event, this factory simply validates the envelope and returns a
  # WebhookNotification - there is no need for a per-event subclass hierarchy.
  class WebhookNotificationFactory
    def create(data)
      raise TypeError, 'Parameter "data" should be a Hash' unless data.is_a?(Hash)

      stringified = data.each_with_object({}) { |(k, v), h| h[k.to_s] = v }
      unless stringified.key?('type') && stringified.key?('event')
        raise ArgumentError, 'Parameter "data" should contain "type" and "event" fields'
      end
      unless stringified['type'] == YooKassa::WebhookNotificationType::NOTIFICATION
        raise TypeError, 'Parameter "data" should contain "type" field'
      end

      YooKassa::WebhookNotification.new(data)
    end
  end
end
