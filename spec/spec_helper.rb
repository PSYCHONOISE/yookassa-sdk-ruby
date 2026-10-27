# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'yookassa'
require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  config.before do
    YooKassa::Configuration.reset!
  end
end

module ConfigureTestClient
  # Configures YooKassa::Configuration for tests with basic auth by default,
  # and a tiny timeout so the ApiClient's 202-retry backoff never actually
  # sleeps for a meaningful amount of time in the test suite.
  def configure_test_client(account_id: 'test_shop_id', secret_key: 'test_secret_key', **opts)
    YooKassa::Configuration.configure(account_id, secret_key, timeout: opts.fetch(:timeout, 10),
                                                               max_attempts: opts.fetch(:max_attempts, 3))
  end

  def configure_test_client_with_token(token = 'test_oauth_token', **opts)
    YooKassa::Configuration.configure_auth_token(token, timeout: opts.fetch(:timeout, 10),
                                                         max_attempts: opts.fetch(:max_attempts, 3))
  end
end

RSpec.configure do |config|
  config.include ConfigureTestClient
end
