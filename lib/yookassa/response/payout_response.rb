# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.response.payout_response.PayoutResponse from the
  # Python SDK.
  class PayoutResponse < BaseObject
    attribute :id, :amount, :status, :payout_destination, :description,
              :created_at, :deal, :cancellation_details, :metadata, :test

    def amount=(value)
      @amount = value.nil? || value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def payout_destination=(value)
      @payout_destination = value.nil? || value.is_a?(YooKassa::PayoutDestination) ? value : YooKassa::PayoutDestination.new(value)
    end

    def deal=(value)
      @deal = value.nil? || value.is_a?(YooKassa::PayoutDealInfo) ? value : YooKassa::PayoutDealInfo.new(value)
    end

    def cancellation_details=(value)
      @cancellation_details = value.nil? || value.is_a?(YooKassa::CancellationDetails) ? value : YooKassa::CancellationDetails.new(value)
    end

    def test=(value)
      @test = value.nil? ? nil : !!value
    end
  end
end
