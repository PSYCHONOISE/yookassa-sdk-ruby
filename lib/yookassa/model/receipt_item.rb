# frozen_string_literal: true

require 'bigdecimal'

module YooKassa
  # Mirrors yookassa.domain.models.receipt_item.ReceiptItem and
  # yookassa.domain.request.receipt_item_request.ReceiptItemRequest from the
  # Python SDK (merged into one class since the fields are identical).
  class ReceiptItem < BaseObject
    attribute :description, :quantity, :amount, :vat_code, :payment_mode,
              :payment_subject, :product_code, :country_of_origin_code,
              :customs_declaration_number, :excise, :supplier, :agent_type

    def quantity=(value)
      @quantity = value.nil? ? nil : BigDecimal(value.to_s)
    end

    def excise=(value)
      @excise = value.nil? ? nil : BigDecimal(value.to_s)
    end

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def vat_code=(value)
      @vat_code = value&.to_i
    end

    def supplier=(value)
      @supplier = value.nil? || value.is_a?(YooKassa::ReceiptItemSupplier) ? value : YooKassa::ReceiptItemSupplier.new(value)
    end
  end

  # Alias kept for parity with the Python SDK's ReceiptItemRequest name. It is
  # the exact same structure as a response receipt item.
  ReceiptItemRequest = ReceiptItem
end
