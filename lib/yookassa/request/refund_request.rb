# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.refund_request.RefundRequest from the
  # Python SDK.
  class RefundRequest < BaseObject
    attribute :payment_id, :amount, :description, :sources, :receipt, :deal

    def payment_id=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid payment id value' unless cast.length == 36

      @payment_id = cast
    end

    def amount=(value)
      @amount = value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def description=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid comment value' if cast.empty? || cast.length >= 256

      @description = cast
    end

    def sources=(value)
      @sources = Array(value).map { |item| item.is_a?(YooKassa::RefundSource) ? item : YooKassa::RefundSource.new(item) }
    end

    def receipt=(value)
      @receipt = value.is_a?(YooKassa::ReceiptData) ? value : YooKassa::ReceiptData.new(value)
    end

    def deal=(value)
      @deal = value.is_a?(YooKassa::RefundDealData) ? value : YooKassa::RefundDealData.new(value)
    end

    def validate
      raise ArgumentError, 'Payment id not specified' if payment_id.nil? || payment_id.empty?
      raise ArgumentError, 'Amount not specified' if amount.nil?
      raise ArgumentError, "Invalid amount value: #{amount.value}" if amount.value <= 0

      return unless receipt&.has_items?

      raise ArgumentError, 'Both email and phone values are empty in receipt' if receipt.email.nil? && receipt.phone.nil?

      return unless receipt.tax_system_code.nil? && receipt.items.any? { |item| item.vat_code.nil? }

      raise ArgumentError, 'Item vat_id and receipt tax_system_id not specified'
    end
  end

  # Fluent builder for YooKassa::RefundRequest.
  class RefundRequestBuilder
    def initialize
      @request = RefundRequest.new
    end

    %i[payment_id amount description receipt sources deal].each do |attr|
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
