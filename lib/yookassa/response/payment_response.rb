# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.response.payment_response.PaymentResponse from
  # the Python SDK.
  class PaymentResponse < BaseObject
    attribute :id, :status, :amount, :income_amount, :description, :recipient,
              :payment_method, :captured_at, :created_at, :expires_at,
              :confirmation, :test, :refunded_amount, :paid, :refundable,
              :receipt_registration, :metadata, :cancellation_details,
              :authorization_details, :transfers, :deal, :merchant_customer_id

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def income_amount=(value)
      @income_amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def refunded_amount=(value)
      @refunded_amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def recipient=(value)
      @recipient = value.nil? || value.is_a?(YooKassa::Recipient) ? value : YooKassa::Recipient.new(value)
    end

    def payment_method=(value)
      @payment_method = value.nil? || value.is_a?(YooKassa::PaymentMethodData) ? value : YooKassa::PaymentMethodData.new(value)
    end

    def confirmation=(value)
      @confirmation = value.nil? || value.is_a?(YooKassa::Confirmation) ? value : YooKassa::Confirmation.new(value)
    end

    def cancellation_details=(value)
      @cancellation_details = value.nil? || value.is_a?(YooKassa::CancellationDetails) ? value : YooKassa::CancellationDetails.new(value)
    end

    def authorization_details=(value)
      @authorization_details = value.nil? || value.is_a?(YooKassa::AuthorizationDetails) ? value : YooKassa::AuthorizationDetails.new(value)
    end

    def transfers=(value)
      @transfers = if value.nil?
                     nil
                   else
                     Array(value).map { |item| item.is_a?(YooKassa::Transfer) ? item : YooKassa::Transfer.new(item) }
                   end
    end

    def deal=(value)
      @deal = value.nil? || value.is_a?(YooKassa::PaymentDealInfo) ? value : YooKassa::PaymentDealInfo.new(value)
    end

    def test=(value)
      @test = value.nil? ? nil : !!value
    end

    def paid=(value)
      @paid = value.nil? ? nil : !!value
    end

    def refundable=(value)
      @refundable = value.nil? ? nil : !!value
    end
  end

  # Mirrors yookassa.domain.response.payment_list_response.PaymentListResponse
  # from the Python SDK.
  class PaymentListResponse < BaseObject
    attribute :type, :next_cursor, :items

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::PaymentResponse) ? item : YooKassa::PaymentResponse.new(item) }
    end
  end
end
