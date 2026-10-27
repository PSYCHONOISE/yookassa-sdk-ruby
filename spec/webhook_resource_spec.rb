# frozen_string_literal: true

RSpec.describe YooKassa::Webhook do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client_with_token }

  describe '.add' do
    it 'POSTs to /webhooks' do
      stub = stub_request(:post, "#{endpoint}/webhooks")
             .with(body: { 'event' => 'payment.succeeded', 'url' => 'https://example.com/hook' })
             .to_return(status: 200, body: '{"id":"wh-1","event":"payment.succeeded","url":"https://example.com/hook"}')

      response = described_class.add(event: 'payment.succeeded', url: 'https://example.com/hook')

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::WebhookResponse)
      expect(response.id).to eq('wh-1')
    end
  end

  describe '.list' do
    it 'GETs /webhooks' do
      stub = stub_request(:get, "#{endpoint}/webhooks").to_return(status: 200, body: '{"items":[]}')

      response = described_class.list

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::WebhookList)
    end
  end

  describe '.remove' do
    it 'DELETEs /webhooks/:id' do
      stub = stub_request(:delete, "#{endpoint}/webhooks/wh-1").to_return(status: 200, body: '{"id":"wh-1"}')

      described_class.remove('wh-1')

      expect(stub).to have_been_requested
    end
  end
end
