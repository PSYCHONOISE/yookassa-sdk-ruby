# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.receipt_item_supplier.ReceiptItemSupplier
  # from the Python SDK.
  class ReceiptItemSupplier < BaseObject
    attribute :name, :inn, :phone
  end
end
