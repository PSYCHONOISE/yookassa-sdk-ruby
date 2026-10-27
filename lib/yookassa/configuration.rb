# frozen_string_literal: true

module YooKassa
  # Holds global SDK configuration: credentials, API endpoint, timeouts and
  # the optional partner "user agent" (framework / cms / module) information.
  #
  # Mirrors yookassa.configuration.Configuration from the Python SDK.
  class Configuration
    API_URL = 'https://api.yookassa.ru/v3'
    DEFAULT_TIMEOUT = 1800
    DEFAULT_MAX_ATTEMPTS = 3

    class << self
      attr_accessor :account_id, :secret_key, :auth_token, :agent_framework, :agent_cms, :agent_module
      attr_writer :timeout, :max_attempts

      # Configure basic (shop_id / secret_key) authorization.
      def configure(account_id, secret_key, **kwargs)
        self.account_id = account_id
        self.secret_key = secret_key
        self.auth_token = nil
        self.timeout = kwargs.fetch(:timeout, DEFAULT_TIMEOUT)
        self.max_attempts = kwargs.fetch(:max_attempts, DEFAULT_MAX_ATTEMPTS)
        assert_has_api_credentials!
      end

      # Configure OAuth token authorization.
      def configure_auth_token(token, **kwargs)
        self.account_id = nil
        self.secret_key = nil
        self.auth_token = token
        self.timeout = kwargs.fetch(:timeout, DEFAULT_TIMEOUT)
        self.max_attempts = kwargs.fetch(:max_attempts, DEFAULT_MAX_ATTEMPTS)
        assert_has_api_credentials!
      end

      # Configure the optional partner user agent fragments.
      #
      # @param framework [YooKassa::Version, nil]
      # @param cms [YooKassa::Version, nil]
      # @param module [YooKassa::Version, nil]
      def configure_user_agent(framework: nil, cms: nil, module: nil)
        self.agent_framework = framework if framework.is_a?(YooKassa::Version)
        self.agent_cms = cms if cms.is_a?(YooKassa::Version)
        self.agent_module = binding.local_variable_get(:module) if binding.local_variable_get(:module).is_a?(YooKassa::Version)
      end

      def api_endpoint
        API_URL
      end

      def timeout
        @timeout ||= DEFAULT_TIMEOUT
      end

      def max_attempts
        @max_attempts ||= DEFAULT_MAX_ATTEMPTS
      end

      def has_api_credentials?
        !account_id.nil? && !secret_key.nil?
      end

      def assert_has_api_credentials!
        if auth_token.nil? && !has_api_credentials?
          raise ConfigurationError, 'account_id and secret_key are required'
        elsif auth_token && has_api_credentials?
          raise ConfigurationError, 'Could not configure authorization with auth_token and basic auth'
        end
      end

      # Resets all configuration. Mostly useful for tests.
      def reset!
        self.account_id = nil
        self.secret_key = nil
        self.auth_token = nil
        self.timeout = DEFAULT_TIMEOUT
        self.max_attempts = DEFAULT_MAX_ATTEMPTS
        self.agent_framework = nil
        self.agent_cms = nil
        self.agent_module = nil
      end
    end
  end
end
