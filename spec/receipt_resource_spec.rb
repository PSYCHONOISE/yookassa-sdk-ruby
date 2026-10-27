# frozen_string_literal: true

RSpec.describe YooKassa::Receipt do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client }

  describe '.create' do
    it 'POSTs to /receipts' do
      stub = stub_request(:post, "#{endpoint}/receipts")
             .with(body: hash_including('type' => 'payment'))
             .to_return(status: 200, body: '{"id":"rec-1","status":"pending"}')

      response = described_class.create(
        type: 'payment', send: true, customer: { email: 'a@b.com' },
        items: [{ description: 'Item', quantity: 1, amount: { value: '1.00', currency: 'RUB' }, vat_code: 1 }],
        settlements: [{ type: 'cashless', amount: { value: '1.00', currency: 'RUB' } }],
        payment_id: 'pay-1'
      )

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::ReceiptResponse)
    end
  end

  describe '.find_one' do
    it 'GETs /receipts/:id' do
      stub = stub_request(:get, "#{endpoint}/receipts/rec-1").to_return(status: 200, body: '{"id":"rec-1"}')

      described_class.find_one('rec-1')

      expect(stub).to have_been_requested
    end
  end

  describe '.list' do
    it 'GETs /receipts' do
      stub = stub_request(:get, "#{endpoint}/receipts").to_return(status: 200, body: '{"items":[]}')

      response = described_class.list

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::ReceiptListResponse)
    end
  end
end
