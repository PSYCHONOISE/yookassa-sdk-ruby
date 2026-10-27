# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.receipt_customer.ReceiptCustomer from the
  # Python SDK.
  class ReceiptCustomer < BaseObject
    attribute :full_name, :inn, :email, :phone

    def email=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid email value' unless cast =~ /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

      @email = cast
    end
  end
end
