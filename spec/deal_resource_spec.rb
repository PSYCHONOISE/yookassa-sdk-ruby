# frozen_string_literal: true

RSpec.describe YooKassa::Deal do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client }

  describe '.create' do
    it 'POSTs to /deals' do
      stub = stub_request(:post, "#{endpoint}/deals")
             .with(body: hash_including('type' => 'safe_deal'))
             .to_return(status: 200, body: '{"id":"deal-1","status":"opened"}')

      response = described_class.create(type: 'safe_deal', fee_moment: 'payment_succeeded')

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::DealResponse)
    end
  end

  describe '.find_one' do
    it 'GETs /deals/:id' do
      stub = stub_request(:get, "#{endpoint}/deals/deal-1").to_return(status: 200, body: '{"id":"deal-1"}')

      described_class.find_one('deal-1')

      expect(stub).to have_been_requested
    end
  end

  describe '.list' do
    it 'GETs /deals' do
      stub = stub_request(:get, "#{endpoint}/deals").to_return(status: 200, body: '{"items":[]}')

      response = described_class.list

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::DealListResponse)
    end
  end
end
