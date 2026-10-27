# frozen_string_literal: true

RSpec.describe YooKassa::Configuration do
  describe '.configure' do
    it 'sets basic auth credentials and clears the auth token' do
      described_class.configure('shop_id', 'secret_key')

      expect(described_class.account_id).to eq('shop_id')
      expect(described_class.secret_key).to eq('secret_key')
      expect(described_class.auth_token).to be_nil
      expect(described_class.timeout).to eq(1800)
      expect(described_class.max_attempts).to eq(3)
    end

    it 'accepts custom timeout and max_attempts' do
      described_class.configure('shop_id', 'secret_key', timeout: 5000, max_attempts: 5)

      expect(described_class.timeout).to eq(5000)
      expect(described_class.max_attempts).to eq(5)
    end
  end

  describe '.configure_auth_token' do
    it 'sets the oauth token and clears basic auth credentials' do
      described_class.configure_auth_token('oauth-token')

      expect(described_class.auth_token).to eq('oauth-token')
      expect(described_class.account_id).to be_nil
      expect(described_class.secret_key).to be_nil
    end
  end

  describe '.assert_has_api_credentials!' do
    it 'raises ConfigurationError when neither auth mode is configured' do
      described_class.reset!

      expect { described_class.assert_has_api_credentials! }.to raise_error(YooKassa::ConfigurationError)
    end

    it 'raises ConfigurationError when both auth modes are configured' do
      described_class.account_id = 'shop_id'
      described_class.secret_key = 'secret_key'
      described_class.auth_token = 'oauth-token'

      expect { described_class.assert_has_api_credentials! }.to raise_error(YooKassa::ConfigurationError)
    end

    it 'does not raise when only basic auth is configured' do
      described_class.configure('shop_id', 'secret_key')

      expect { described_class.assert_has_api_credentials! }.not_to raise_error
    end

    it 'does not raise when only the oauth token is configured' do
      described_class.configure_auth_token('oauth-token')

      expect { described_class.assert_has_api_credentials! }.not_to raise_error
    end
  end

  describe '.configure_user_agent' do
    it 'stores Version instances for framework/cms/module' do
      framework = YooKassa::Version.new('Django', '2.2.3')
      cms = YooKassa::Version.new('Wagtail', '2.6.2')
      mod = YooKassa::Version.new('Y.CMS', '0.0.1')

      described_class.configure_user_agent(framework: framework, cms: cms, module: mod)

      expect(described_class.agent_framework).to eq(framework)
      expect(described_class.agent_cms).to eq(cms)
      expect(described_class.agent_module).to eq(mod)
    end

    it 'ignores values that are not a YooKassa::Version' do
      described_class.configure_user_agent(framework: 'Django', cms: nil, module: nil)

      expect(described_class.agent_framework).to be_nil
    end
  end

  describe '.api_endpoint' do
    it 'returns the YooKassa API v3 base url' do
      expect(described_class.api_endpoint).to eq('https://api.yookassa.ru/v3')
    end
  end
end
