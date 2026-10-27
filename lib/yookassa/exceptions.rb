# frozen_string_literal: true

module YooKassa
  # Base class for all errors raised by the YooKassa API client.
  #
  # Mirrors yookassa.domain.exceptions.api_error.ApiError from the Python SDK.
  class ApiError < StandardError
    # @return [Object] the raw, parsed response body (usually a Hash) returned by the API,
    #   or the raw response text when the body could not be parsed as JSON.
    attr_reader :response_body

    def initialize(response_body = nil)
      @response_body = response_body
      super(response_body.is_a?(String) ? response_body : response_body.inspect)
    end
  end

  # Raised when authorization with the API fails in a generic way.
  class AuthorizeError < ApiError
  end

  # HTTP 400
  class BadRequestError < ApiError
    HTTP_CODE = 400
  end

  # HTTP 403
  class ForbiddenError < ApiError
    HTTP_CODE = 403
  end

  # HTTP 404
  class NotFoundError < ApiError
    HTTP_CODE = 404
  end

  # HTTP 429
  class TooManyRequestsError < ApiError
    HTTP_CODE = 429
  end

  # HTTP 401
  class UnauthorizedError < ApiError
    HTTP_CODE = 401
  end

  # HTTP 202 - raised only once retries are exhausted.
  class ResponseProcessingError < ApiError
    HTTP_CODE = 202
  end

  # Raised by YooKassa::Configuration when the SDK is misconfigured.
  class ConfigurationError < StandardError
  end
end
