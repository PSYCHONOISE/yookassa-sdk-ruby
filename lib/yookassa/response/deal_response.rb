# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.response.deal_response.DealResponse from the
  # Python SDK.
  class DealResponse < BaseObject
    attribute :id, :type, :status, :balance, :payout_balance, :description,
              :fee_moment, :created_at, :expires_at, :test, :metadata

    def balance=(value)
      @balance = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def payout_balance=(value)
      @payout_balance = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def test=(value)
      @test = value.nil? ? nil : !!value
    end
  end

  # Mirrors yookassa.domain.response.deal_list_response.DealListResponse from
  # the Python SDK.
  class DealListResponse < BaseObject
    attribute :type, :next_cursor, :items

    def items=(value)
      @items = Array(value).map { |item| item.is_a?(YooKassa::DealResponse) ? item : YooKassa::DealResponse.new(item) }
    end
  end
end
