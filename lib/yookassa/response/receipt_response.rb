# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.response.receipt_item_response.ReceiptItemResponse
  # from the Python SDK.
  class ReceiptItemResponse < BaseObject
    attribute :description, :quantity, :amount, :vat_code, :payment_subject,
              :payment_mode, :supplier, :agent_type

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def supplier=(value)
      @supplier = value.nil? || value.is_a?(YooKassa::ReceiptItemSupplier) ? value : YooKassa::ReceiptItemSupplier.new(value)
    end
  end

  # Mirrors yookassa.domain.response.receipt_response.ReceiptResponse from
  # the Python SDK.
  class ReceiptResponse < BaseObject
    attribute :id, :type, :payment_id, :refund_id, :status,
              :fiscal_document_number, :fiscal_storage_number, :fiscal_attribute,
              :registered_at, :fiscal_provider_id, :tax_system_code, :items,
              :settlements, :on_behalf_of

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::ReceiptItemResponse) ? item : YooKassa::ReceiptItemResponse.new(item) }
    end

    def settlements=(value)
      @settlements = Array(value).map { |item| item.is_a?(YooKassa::Settlement) ? item : YooKassa::Settlement.new(item) }
    end
  end

  # Mirrors yookassa.domain.response.receipt_list_response.ReceiptListResponse
  # from the Python SDK.
  class ReceiptListResponse < BaseObject
    attribute :type, :next_cursor, :items

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::ReceiptResponse) ? item : YooKassa::ReceiptResponse.new(item) }
    end
  end
end
