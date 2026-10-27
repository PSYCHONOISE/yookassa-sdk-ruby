# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.domain.models.airline.Airline from the Python SDK.
  class Airline < BaseObject
    attribute :booking_reference, :ticket_number, :passengers, :legs

    def passengers=(value)
      @passengers = Array(value).map { |item| item.is_a?(Passenger) ? item : Passenger.new(item) }
    end

    def legs=(value)
      @legs = Array(value).map { |item| item.is_a?(Leg) ? item : Leg.new(item) }
    end

    # Mirrors the nested Passenger class from airline.py
    class Passenger < BaseObject
      attribute :first_name, :last_name
    end

    # Mirrors the nested Leg class from airline.py
    class Leg < BaseObject
      attribute :departure_airport, :destination_airport, :departure_date
    end
  end
end
