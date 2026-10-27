# frozen_string_literal: true

RSpec.describe YooKassa::Refund do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client }

  describe '.create' do
    it 'POSTs to /refunds' do
      stub = stub_request(:post, "#{endpoint}/refunds")
             .with(body: hash_including('payment_id' => '2' * 36))
             .to_return(status: 200, body: '{"id":"ref-1","status":"succeeded"}')

      response = described_class.create(payment_id: '2' * 36, amount: { value: '5.00', currency: 'RUB' })

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::RefundResponse)
    end
  end

  describe '.find_one' do
    it 'GETs /refunds/:id' do
      stub = stub_request(:get, "#{endpoint}/refunds/ref-1").to_return(status: 200, body: '{"id":"ref-1"}')

      described_class.find_one('ref-1')

      expect(stub).to have_been_requested
    end
  end

  describe '.list' do
    it 'GETs /refunds' do
      stub = stub_request(:get, "#{endpoint}/refunds").to_return(status: 200, body: '{"items":[]}')

      response = described_class.list

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::RefundListResponse)
    end
  end
end
