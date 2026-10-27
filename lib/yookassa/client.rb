# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'base64'

module YooKassa
  # Performs authenticated HTTP requests against the YooKassa API.
  #
  # Mirrors yookassa.client.ApiClient from the Python SDK.
  class ApiClient
    def self.endpoint
      YooKassa::Configuration.api_endpoint
    end

    attr_reader :shop_id, :shop_password, :auth_token, :timeout, :max_attempts, :user_agent

    def initialize
      @shop_id = YooKassa::Configuration.account_id
      @shop_password = YooKassa::Configuration.secret_key
      @auth_token = YooKassa::Configuration.auth_token
      @timeout = YooKassa::Configuration.timeout
      @max_attempts = YooKassa::Configuration.max_attempts

      @user_agent = YooKassa::UserAgent.new
      @user_agent.framework = YooKassa::Configuration.agent_framework if YooKassa::Configuration.agent_framework
      @user_agent.cms = YooKassa::Configuration.agent_cms if YooKassa::Configuration.agent_cms
      @user_agent.module_info = YooKassa::Configuration.agent_module if YooKassa::Configuration.agent_module
    end

    # @param method [String] one of YooKassa::HttpVerb
    # @param path [String] API path, e.g. "/payments"
    # @param query_params [Hash, nil]
    # @param headers [Hash, nil] extra request headers
    # @param body [YooKassa::BaseObject, Hash, nil]
    # @return [Hash] the parsed JSON response body
    def request(method:, path:, query_params: nil, headers: nil, body: nil)
      if body.is_a?(YooKassa::BaseObject)
        body.validate if body.respond_to?(:validate)
        body = body.to_h
      end

      request_headers = prepare_request_headers(headers)
      raw_response = execute(body: body, method: method, path: path, query_params: query_params,
                             headers: request_headers)

      handle_response(raw_response)
    end

    def prepare_request_headers(headers)
      request_headers = { 'Content-Type' => 'application/json' }
      request_headers['Authorization'] = if auth_token
                                           "Bearer #{auth_token}"
                                         else
                                           "Basic #{Base64.strict_encode64("#{shop_id}:#{shop_password}")}"
                                         end
      request_headers['YM-User-Agent'] = user_agent.get_header_string
      request_headers.merge!(headers) if headers.is_a?(Hash)
      request_headers
    end

    private

    def execute(body:, method:, path:, query_params:, headers:)
      uri = build_uri(path, query_params)

      attempt = 0
      response = nil
      loop do
        attempt += 1
        response = perform_http(method, uri, headers, body)
        break unless response.code.to_i == ResponseProcessingError::HTTP_CODE && attempt < max_attempts

        sleep(backoff_delay(attempt))
      end
      response
    end

    def build_uri(path, query_params)
      uri = URI.parse("#{self.class.endpoint}#{path}")
      uri.query = URI.encode_www_form(normalize_query(query_params)) if query_params && !query_params.empty?
      uri
    end

    def normalize_query(query_params)
      query_params.is_a?(YooKassa::BaseObject) ? query_params.to_h : query_params
    end

    def perform_http(method, uri, headers, body)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.read_timeout = [(timeout.to_f / 1000.0), 1].max
      http.open_timeout = [(timeout.to_f / 1000.0), 1].max

      request = build_request(method, uri, headers, body)
      http.request(request)
    end

    def build_request(method, uri, headers, body)
      request_class = {
        YooKassa::HttpVerb::GET => Net::HTTP::Get,
        YooKassa::HttpVerb::POST => Net::HTTP::Post,
        YooKassa::HttpVerb::PUT => Net::HTTP::Put,
        YooKassa::HttpVerb::PATCH => Net::HTTP::Patch,
        YooKassa::HttpVerb::DELETE => Net::HTTP::Delete,
        YooKassa::HttpVerb::HEAD => Net::HTTP::Head,
        YooKassa::HttpVerb::OPTIONS => Net::HTTP::Options
      }.fetch(method.to_s.downcase, Net::HTTP::Get)

      request = request_class.new(uri)
      headers.each { |key, value| request[key] = value }
      request.body = JSON.generate(body) if !body.nil? && request_class != Net::HTTP::Get && request_class != Net::HTTP::Head
      request
    end

    # Mirrors urllib3.Retry's backoff: backoff_factor * (2 ** (retry_count - 1)),
    # with backoff_factor = timeout(ms) / 1000 seconds.
    def backoff_delay(attempt)
      backoff_factor = timeout.to_f / 1000.0
      delay = backoff_factor * (2**(attempt - 1))
      [delay, 10].min
    end

    def handle_response(raw_response)
      status = raw_response.code.to_i
      return parse_json(raw_response.body) if status == 200

      raise_error_for(status, raw_response)
    end

    def raise_error_for(status, raw_response)
      parsed_body = parse_json(raw_response.body) || raw_response.body

      case status
      when BadRequestError::HTTP_CODE then raise BadRequestError, parsed_body
      when ForbiddenError::HTTP_CODE then raise ForbiddenError, parsed_body
      when NotFoundError::HTTP_CODE then raise NotFoundError, parsed_body
      when TooManyRequestsError::HTTP_CODE then raise TooManyRequestsError, parsed_body
      when UnauthorizedError::HTTP_CODE then raise UnauthorizedError, parsed_body
      when ResponseProcessingError::HTTP_CODE then raise ResponseProcessingError, parsed_body
      else
        raise ApiError, raw_response.body
      end
    end

    def parse_json(text)
      return nil if text.nil? || text.empty?

      JSON.parse(text)
    rescue JSON::ParserError
      nil
    end
  end
end
