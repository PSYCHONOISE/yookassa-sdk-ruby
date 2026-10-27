# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.response.refund_response.RefundResponse from the
  # Python SDK.
  class RefundResponse < BaseObject
    attribute :id, :payment_id, :status, :receipt_registration, :created_at,
              :amount, :description, :sources, :deal, :cancellation_details

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def sources=(value)
      @sources = if value.nil?
                   nil
                 else
                   Array(value).map { |item| item.is_a?(YooKassa::RefundSource) ? item : YooKassa::RefundSource.new(item) }
                 end
    end

    def deal=(value)
      @deal = value.nil? || value.is_a?(YooKassa::RefundDealInfo) ? value : YooKassa::RefundDealInfo.new(value)
    end

    def cancellation_details=(value)
      @cancellation_details = value.nil? || value.is_a?(YooKassa::CancellationDetails) ? value : YooKassa::CancellationDetails.new(value)
    end
  end

  # Mirrors yookassa.domain.response.refund_list_response.RefundListResponse
  # from the Python SDK.
  class RefundListResponse < BaseObject
    attribute :type, :next_cursor, :items

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::RefundResponse) ? item : YooKassa::RefundResponse.new(item) }
    end
  end
end
