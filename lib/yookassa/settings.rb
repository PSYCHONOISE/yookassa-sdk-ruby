# frozen_string_literal: true

module YooKassa
  # Mirrors yookassa.settings.Settings from the Python SDK.
  class Settings
    include YooKassa::ResourceHelpers

    BASE_PATH = '/me'

    class << self
      # Shop info.
      #
      # @param params [Hash, nil] currently only {on_behalf_of: account_id} is supported.
      # @return [Hash] the raw parsed response (the Python SDK also returns a plain dict here).
      def get_account_settings(params = nil)
        client.request(method: YooKassa::HttpVerb::GET, path: BASE_PATH, query_params: params)
      end
    end
  end
end
