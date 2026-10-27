# frozen_string_literal: true

RSpec.describe YooKassa::Payment do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  before { configure_test_client }

  describe '.create' do
    it 'POSTs to /payments with a generated Idempotence-Key when params is a Hash' do
      stub = stub_request(:post, "#{endpoint}/payments")
             .with(body: hash_including('amount' => { 'value' => '10.00', 'currency' => 'RUB' })) do |req|
               req.headers.key?('Idempotence-Key')
             end
             .to_return(status: 200, body: '{"id":"pay-1","status":"pending"}', headers: { 'Content-Type' => 'application/json' })

      response = described_class.create(amount: { value: '10.00', currency: 'RUB' }, confirmation: { type: 'redirect', return_url: 'https://x' })

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::PaymentResponse)
      expect(response.id).to eq('pay-1')
    end

    it 'accepts a PaymentRequest object and uses the given idempotency_key' do
      request = YooKassa::PaymentRequestBuilder.new
                                                .set_amount(value: '10.00', currency: 'RUB')
                                                .set_confirmation(type: 'redirect', return_url: 'https://x')
                                                .build
      stub = stub_request(:post, "#{endpoint}/payments")
             .with(headers: { 'Idempotence-Key' => 'my-key' })
             .to_return(status: 200, body: '{"id":"pay-2"}')

      described_class.create(request, 'my-key')

      expect(stub).to have_been_requested
    end

    it 'raises TypeError for an invalid params type' do
      expect { described_class.create(42) }.to raise_error(TypeError)
    end
  end

  describe '.find_one' do
    it 'GETs /payments/:id' do
      stub = stub_request(:get, "#{endpoint}/payments/pay-1")
             .to_return(status: 200, body: '{"id":"pay-1","status":"succeeded"}')

      response = described_class.find_one('pay-1')

      expect(stub).to have_been_requested
      expect(response.status).to eq('succeeded')
    end

    it 'raises ArgumentError for a blank payment_id' do
      expect { described_class.find_one('') }.to raise_error(ArgumentError)
    end
  end

  describe '.capture' do
    it 'POSTs to /payments/:id/capture' do
      stub = stub_request(:post, "#{endpoint}/payments/pay-1/capture")
             .with(body: hash_including('amount' => { 'value' => '10.00', 'currency' => 'RUB' }))
             .to_return(status: 200, body: '{"id":"pay-1","status":"succeeded"}')

      response = described_class.capture('pay-1', amount: { value: '10.00', currency: 'RUB' })

      expect(stub).to have_been_requested
      expect(response.status).to eq('succeeded')
    end

    it 'allows capturing without params' do
      stub = stub_request(:post, "#{endpoint}/payments/pay-1/capture")
             .to_return(status: 200, body: '{"id":"pay-1"}')

      described_class.capture('pay-1')

      expect(stub).to have_been_requested
    end
  end

  describe '.cancel' do
    it 'POSTs to /payments/:id/cancel' do
      stub = stub_request(:post, "#{endpoint}/payments/pay-1/cancel")
             .to_return(status: 200, body: '{"id":"pay-1","status":"canceled"}')

      response = described_class.cancel('pay-1')

      expect(stub).to have_been_requested
      expect(response.status).to eq('canceled')
    end
  end

  describe '.list' do
    it 'GETs /payments with query params' do
      stub = stub_request(:get, "#{endpoint}/payments")
             .with(query: { 'limit' => '10' })
             .to_return(status: 200, body: '{"type":"list","items":[]}')

      response = described_class.list(limit: 10)

      expect(stub).to have_been_requested
      expect(response).to be_a(YooKassa::PaymentListResponse)
    end
  end
end
