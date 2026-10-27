# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.capture_payment_request.CapturePaymentRequest
  # from the Python SDK.
  class CapturePaymentRequest < BaseObject
    attribute :amount, :receipt, :airline, :transfers, :metadata

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def receipt=(value)
      @receipt = value.nil? || value.is_a?(YooKassa::ReceiptData) ? value : YooKassa::ReceiptData.new(value)
    end

    def airline=(value)
      @airline = value.nil? || value.is_a?(YooKassa::Airline) ? value : YooKassa::Airline.new(value)
    end

    def transfers=(value)
      @transfers = Array(value).map { |item| item.is_a?(YooKassa::Transfer) ? item : YooKassa::Transfer.new(item) }
    end

    def validate
      raise ArgumentError, "Invalid amount value: #{amount.value}" if amount && (amount.value.nil? || amount.value <= 0)

      return unless receipt&.has_items?

      raise ArgumentError, 'Both email and phone values are empty in receipt' if receipt.email.nil? && receipt.phone.nil?

      return unless receipt.tax_system_code.nil? && receipt.items.any? { |item| item.vat_code.nil? }

      raise ArgumentError, 'Item vat_id and receipt tax_system_id not specified'
    end
  end

  # Fluent builder for YooKassa::CapturePaymentRequest.
  class CapturePaymentBuilder
    def initialize
      @request = CapturePaymentRequest.new
    end

    %i[amount receipt airline metadata transfers].each do |attr|
      define_method(:"set_#{attr}") do |value|
        @request.public_send(:"#{attr}=", value)
        self
      end
    end

    def build
      @request
    end
  end
end
