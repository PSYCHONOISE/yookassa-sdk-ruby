# frozen_string_literal: true

module YooKassa
  # Generic confirmation data object.
  #
  # The Python SDK models every confirmation `type` (redirect, embedded,
  # external, qr, mobile_application) as its own request/response class.
  # This Ruby port intentionally merges them into one flexible class driven
  # by the `type` attribute, with every other documented field (return_url,
  # enforce, locale, confirmation_url, confirmation_token, confirmation_data, ...)
  # accepted as a pass-through attribute. All confirmation types from the
  # Python SDK are supported, just not as separate classes.
  class Confirmation < BaseObject
    attribute :type

    def type=(value)
      @type = value&.to_s
    end
  end
end
