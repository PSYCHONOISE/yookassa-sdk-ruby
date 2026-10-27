# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.payment_request.PaymentRequest from the
  # Python SDK.
  class PaymentRequest < BaseObject
    DESCRIPTION_MAX_LENGTH = 128
    MERCHANT_CUSTOMER_MAX_LENGTH = 200

    attribute :amount, :description, :receipt, :recipient, :payment_token,
              :payment_method_id, :payment_method_data, :confirmation,
              :save_payment_method, :capture, :client_ip, :metadata, :airline,
              :transfers, :deal, :merchant_customer_id

    def amount=(value)
      @amount = value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def description=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid description value' if cast.empty?
      if cast.length > DESCRIPTION_MAX_LENGTH
        raise ArgumentError, "The value of the description parameter is too long. Max length is #{DESCRIPTION_MAX_LENGTH}"
      end

      @description = cast
    end

    def receipt=(value)
      @receipt = value.is_a?(YooKassa::ReceiptData) ? value : YooKassa::ReceiptData.new(value)
    end

    def recipient=(value)
      @recipient = value.is_a?(YooKassa::Recipient) ? value : YooKassa::Recipient.new(value)
    end

    def payment_method_data=(value)
      @payment_method_data = value.is_a?(YooKassa::PaymentMethodData) ? value : YooKassa::PaymentMethodData.new(value)
    end

    def confirmation=(value)
      @confirmation = value.is_a?(YooKassa::Confirmation) ? value : YooKassa::Confirmation.new(value)
    end

    def save_payment_method=(value)
      @save_payment_method = !!value
    end

    def capture=(value)
      @capture = !!value
    end

    def airline=(value)
      @airline = value.is_a?(YooKassa::Airline) ? value : YooKassa::Airline.new(value)
    end

    def transfers=(value)
      @transfers = Array(value).map { |item| item.is_a?(YooKassa::Transfer) ? item : YooKassa::Transfer.new(item) }
    end

    def deal=(value)
      @deal = value.is_a?(YooKassa::PaymentDealInfo) ? value : YooKassa::PaymentDealInfo.new(value)
    end

    def merchant_customer_id=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid merchant_customer_id value' if cast.empty?
      if cast.length > MERCHANT_CUSTOMER_MAX_LENGTH
        raise ArgumentError,
              "The value of the merchant_customer_id parameter is too long. Max length is #{MERCHANT_CUSTOMER_MAX_LENGTH}"
      end

      @merchant_customer_id = cast
    end

    def validate
      raise ArgumentError, 'Payment amount not specified' if amount.nil?
      raise ArgumentError, "Invalid payment amount value: #{amount.value}" if amount.value <= 0

      validate_receipt
      validate_payment_method
    end

    private

    def validate_receipt
      return unless receipt&.has_items?

      raise ArgumentError, 'Both email and phone values are empty in receipt' if receipt.email.nil? && receipt.phone.nil?

      return unless receipt.tax_system_code.nil?

      return unless receipt.items.any? { |item| item.vat_code.nil? }

      raise ArgumentError, 'Item vat_code and receipt tax_system_id not specified'
    end

    def validate_payment_method
      raise ArgumentError, 'Both payment_token and payment_method_id values are specified' if payment_token && payment_method_id

      raise ArgumentError, 'Both payment_token and payment_data values are specified' if payment_token && payment_method_data

      return unless !payment_token && payment_method_id && payment_method_data

      raise ArgumentError, 'Both payment_method_id and payment_data values are specified'
    end
  end

  # Fluent builder for YooKassa::PaymentRequest.
  class PaymentRequestBuilder
    def initialize
      @request = PaymentRequest.new
    end

    %i[recipient amount description receipt payment_token payment_method_id
       payment_method_data confirmation save_payment_method capture
       client_ip airline metadata transfers deal merchant_customer_id].each do |attr|
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
