# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.request.deal_request.DealRequest from the Python SDK.
  class DealRequest < BaseObject
    DESCRIPTION_MAX_LENGTH = 128

    attribute :type, :fee_moment, :description, :metadata

    def type=(value)
      @type = value&.to_s
    end

    def fee_moment=(value)
      @fee_moment = value&.to_s
    end

    def description=(value)
      cast = value.to_s
      raise ArgumentError, 'Invalid description value' if cast.empty?
      if cast.length > DESCRIPTION_MAX_LENGTH
        raise ArgumentError, "The value of the description parameter is too long. Max length is #{DESCRIPTION_MAX_LENGTH}"
      end

      @description = cast
    end

    def validate
      raise ArgumentError, 'Deal type not specified' if type.nil?
      raise ArgumentError, 'Deal fee_moment not specified' if fee_moment.nil?
    end
  end

  # Fluent builder for YooKassa::DealRequest.
  class DealRequestBuilder
    def initialize
      @request = DealRequest.new
    end

    %i[type fee_moment description metadata].each do |attr|
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
