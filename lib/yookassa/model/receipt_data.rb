# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.receipt.Receipt from the Python SDK: the
  # `receipt` sub-object embedded in a payment/capture/refund request (used
  # for 54-FZ compliant cash register receipts).
  #
  # Named ReceiptData (rather than Receipt) to avoid clashing with
  # YooKassa::Receipt, the top-level Receipts API resource class.
  class ReceiptData < BaseObject
    attribute :customer, :items, :tax_system_code

    def customer=(value)
      @customer = value.nil? || value.is_a?(YooKassa::ReceiptCustomer) ? value : YooKassa::ReceiptCustomer.new(value)
    end

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::ReceiptItem) ? item : YooKassa::ReceiptItem.new(item) }
    end

    def tax_system_code=(value)
      @tax_system_code = value&.to_i
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

    def has_items?
      !items.nil? && !items.empty?
    end
  end
end
