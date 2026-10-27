# frozen_string_literal: true

RSpec.describe YooKassa::Payout do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client }

  describe '.create' do
    it 'POSTs to /payouts' do
      stub = stub_request(:post, "#{endpoint}/payouts")
             .with(body: hash_including('amount' => { 'value' => '100.00', 'currency' => 'RUB' }))
             .to_return(status: 200, body: '{"id":"po-1","status":"succeeded"}')

      response = described_class.create(
        amount: { value: '100.00', currency: 'RUB' },
        payout_destination_data: { type: 'bank_card', card: { number: '5555555555554444' } }
      )

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::PayoutResponse)
    end
  end

  describe '.find_one' do
    it 'GETs /payouts/:id' do
      stub = stub_request(:get, "#{endpoint}/payouts/po-1").to_return(status: 200, body: '{"id":"po-1"}')

      described_class.find_one('po-1')

      expect(stub).to have_been_requested
    end
  end
end
