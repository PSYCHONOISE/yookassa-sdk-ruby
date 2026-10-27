# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.payout_request.PayoutRequest from the
  # Python SDK.
  class PayoutRequest < BaseObject
    DESCRIPTION_MAX_LENGTH = 128

    attribute :amount, :description, :payout_destination_data, :payout_token, :deal, :metadata

    def amount=(value)
      @amount = value.is_a?(YooKassa::Amount) ? value : YooKassa::Amount.new(value)
    end

    def description=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid description value' if cast.empty?
      if cast.length > DESCRIPTION_MAX_LENGTH
        raise ArgumentError, "The value of the description parameter is too long. Max length is #{DESCRIPTION_MAX_LENGTH}"
      end

      @description = cast
    end

    def payout_destination_data=(value)
      @payout_destination_data = value.is_a?(YooKassa::PayoutDestination) ? value : YooKassa::PayoutDestination.new(value)
    end

    def deal=(value)
      @deal = value.is_a?(YooKassa::PayoutDealInfo) ? value : YooKassa::PayoutDealInfo.new(value)
    end

    def validate
      raise ArgumentError, 'Payout amount not specified' if amount.nil?
      raise ArgumentError, "Invalid payout amount value: #{amount.value}" if amount.value <= 0

      if payout_token && payout_destination_data
        raise ArgumentError, 'Both payout_token and payout_destination_data values are specified'
      end

      return unless payout_token.nil? && payout_destination_data.nil?

      raise ArgumentError, 'Both payout_token and payout_destination_data values are not specified'
    end
  end

  # Fluent builder for YooKassa::PayoutRequest.
  class PayoutRequestBuilder
    def initialize
      @request = PayoutRequest.new
    end

    %i[amount description payout_token payout_destination_data deal metadata].each do |attr|
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
