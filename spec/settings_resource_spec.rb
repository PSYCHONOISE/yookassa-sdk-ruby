# frozen_string_literal: true

RSpec.describe YooKassa::Settings do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client }

  describe '.get_account_settings' do
    it 'GETs /me' do
      stub = stub_request(:get, "#{endpoint}/me").to_return(status: 200, body: '{"account_id":"123","test":false}')

      response = described_class.get_account_settings

      expect(stub).to have_been_requested
      expect(response).to eq('account_id' => '123', 'test' => false)
    end

    it 'passes on_behalf_of as a query param' do
      stub = stub_request(:get, "#{endpoint}/me").with(query: { 'on_behalf_of' => 'shop-1' })
                                                   .to_return(status: 200, body: '{}')

      described_class.get_account_settings(on_behalf_of: 'shop-1')

      expect(stub).to have_been_requested
    end
  end
end
