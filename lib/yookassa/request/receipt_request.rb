# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.receipt_request.ReceiptRequest from the
  # Python SDK: the request body for creating a standalone receipt via the
  # Receipts API (as opposed to YooKassa::ReceiptData, which is the `receipt`
  # sub-object embedded in a payment/refund).
  class ReceiptRequest < BaseObject
    attribute :type, :send, :customer, :tax_system_code, :items, :settlements,
              :payment_id, :refund_id, :on_behalf_of

    def type=(value)
      @type = value&.to_s
    end

    def customer=(value)
      @customer = value.nil? || value.is_a?(YooKassa::ReceiptCustomer) ? value : YooKassa::ReceiptCustomer.new(value)
    end

    def email
      customer&.email
    end

    def email=(value)
      self.customer ||= YooKassa::ReceiptCustomer.new
      customer.email = value.to_s
    end

    def phone
      customer&.phone
    end

    def phone=(value)
      self.customer ||= YooKassa::ReceiptCustomer.new
      customer.phone = value.to_s
    end

    def tax_system_code=(value)
      @tax_system_code = value&.to_i
    end

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::ReceiptItemRequest) ? item : YooKassa::ReceiptItemRequest.new(item) }
    end

    def settlements=(value)
      @settlements = Array(value).map { |item| item.is_a?(YooKassa::Settlement) ? item : YooKassa::Settlement.new(item) }
    end

    def payment_id=(value)
      @refund_id = nil
      @payment_id = value.to_s
    end

    def refund_id=(value)
      @payment_id = nil
      @refund_id = value.to_s
    end

    def has_items?
      !items.nil? && !items.empty?
    end

    def has_settlements?
      !settlements.nil? && !settlements.empty?
    end

    def validate
      raise ArgumentError, 'Receipt type not specified' if type.nil?
      raise ArgumentError, 'Receipt send not specified' if send.nil?

      if customer.nil?
        raise ArgumentError, 'Receipt customer not specified'
      elsif customer.email.nil? && customer.phone.nil?
        raise ArgumentError, 'Both email and phone values are empty in customer'
      end

      raise ArgumentError, 'Receipt items not specified' unless has_items?
      raise ArgumentError, 'Receipt settlements not specified' unless has_settlements?

      raise ArgumentError, 'Receipt payment_id not specified' if type == YooKassa::ReceiptType::PAYMENT && payment_id.nil?

      return unless type == YooKassa::ReceiptType::REFUND && refund_id.nil? && payment_id.nil?

      raise ArgumentError, 'Receipt refund_id or payment_id not specified'
    end
  end

  # Fluent builder for YooKassa::ReceiptRequest.
  class ReceiptRequestBuilder
    def initialize
      @request = ReceiptRequest.new
    end

    %i[type send customer tax_system_code items settlements payment_id refund_id on_behalf_of].each do |attr|
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
