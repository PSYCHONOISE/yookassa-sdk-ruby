# frozen_string_literal: true

RSpec.describe YooKassa::ApiClient do
  let(:endpoint) { YooKassa::Configuration.api_endpoint }

  describe 'authorization headers' do
    it 'sends Basic auth when configured with shop_id/secret_key' do
      configure_test_client(account_id: 'shop_id', secret_key: 'secret_key')
      stub = stub_request(:get, "#{endpoint}/payments/123")
             .with(headers: { 'Authorization' => "Basic #{Base64.strict_encode64('shop_id:secret_key')}" })
             .to_return(status: 200, body: '{"id":"123"}', headers: { 'Content-Type' => 'application/json' })

      described_class.new.request(method: 'get', path: '/payments/123')

      expect(stub).to have_been_requested
    end

    it 'sends Bearer auth when configured with an oauth token' do
      configure_test_client_with_token('my-oauth-token')
      stub = stub_request(:get, "#{endpoint}/payments/123")
             .with(headers: { 'Authorization' => 'Bearer my-oauth-token' })
             .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

      described_class.new.request(method: 'get', path: '/payments/123')

      expect(stub).to have_been_requested
    end

    it 'always sends a YM-User-Agent header' do
      configure_test_client
      stub = stub_request(:get, "#{endpoint}/payments/123")
             .with { |req| req.headers['Ym-User-Agent'] && req.headers['Ym-User-Agent'].include?('YooKassa.Ruby') }
             .to_return(status: 200, body: '{}')

      described_class.new.request(method: 'get', path: '/payments/123')

      expect(stub).to have_been_requested
    end

    it 'merges extra headers, including Idempotence-Key' do
      configure_test_client
      stub = stub_request(:post, "#{endpoint}/payments")
             .with(headers: { 'Idempotence-Key' => 'abc-123' })
             .to_return(status: 200, body: '{}')

      described_class.new.request(method: 'post', path: '/payments', headers: { 'Idempotence-Key' => 'abc-123' })

      expect(stub).to have_been_requested
    end
  end

  describe 'successful requests' do
    it 'returns the parsed JSON body on HTTP 200' do
      configure_test_client
      stub_request(:get, "#{endpoint}/payments/123")
        .to_return(status: 200, body: '{"id":"123","status":"succeeded"}', headers: { 'Content-Type' => 'application/json' })

      result = described_class.new.request(method: 'get', path: '/payments/123')

      expect(result).to eq('id' => '123', 'status' => 'succeeded')
    end

    it 'sends the request body as JSON for a BaseObject payload' do
      configure_test_client
      request = YooKassa::PaymentRequest.new(amount: { value: '10.00', currency: 'RUB' }, confirmation: { type: 'redirect', return_url: 'https://x' })

      stub = stub_request(:post, "#{endpoint}/payments")
             .with(body: hash_including('amount' => { 'value' => '10.00', 'currency' => 'RUB' }))
             .to_return(status: 200, body: '{"id":"1"}')

      described_class.new.request(method: 'post', path: '/payments', body: request)

      expect(stub).to have_been_requested
    end

    it 'sends query params for GET requests' do
      configure_test_client
      stub = stub_request(:get, "#{endpoint}/payments")
             .with(query: { 'limit' => '5' })
             .to_return(status: 200, body: '{"items":[]}')

      described_class.new.request(method: 'get', path: '/payments', query_params: { limit: 5 })

      expect(stub).to have_been_requested
    end
  end

  describe 'error handling' do
    {
      400 => YooKassa::BadRequestError,
      401 => YooKassa::UnauthorizedError,
      403 => YooKassa::ForbiddenError,
      404 => YooKassa::NotFoundError,
      429 => YooKassa::TooManyRequestsError
    }.each do |status, error_class|
      it "raises #{error_class} on HTTP #{status}" do
        configure_test_client
        stub_request(:get, "#{endpoint}/payments/123")
          .to_return(status: status, body: '{"type":"error","code":"invalid_request"}', headers: { 'Content-Type' => 'application/json' })

        expect { described_class.new.request(method: 'get', path: '/payments/123') }.to raise_error(error_class) do |error|
          expect(error.response_body).to eq('type' => 'error', 'code' => 'invalid_request')
        end
      end
    end

    it 'raises a generic ApiError for unexpected status codes' do
      configure_test_client
      stub_request(:get, "#{endpoint}/payments/123").to_return(status: 500, body: 'boom')

      expect { described_class.new.request(method: 'get', path: '/payments/123') }.to raise_error(YooKassa::ApiError)
    end

    it 'retries on 202 and eventually raises ResponseProcessingError once attempts are exhausted' do
      configure_test_client(timeout: 1, max_attempts: 3)
      stub = stub_request(:get, "#{endpoint}/payments/123")
             .to_return(status: 202, body: '{"type":"error"}')

      expect { described_class.new.request(method: 'get', path: '/payments/123') }.to raise_error(YooKassa::ResponseProcessingError)
      expect(stub).to have_been_requested.times(3)
    end

    it 'succeeds if a 202 is followed by a 200 within max_attempts' do
      configure_test_client(timeout: 1, max_attempts: 3)
      stub_request(:get, "#{endpoint}/payments/123")
        .to_return({ status: 202, body: '{}' }, { status: 200, body: '{"id":"123"}' })

      result = described_class.new.request(method: 'get', path: '/payments/123')

      expect(result).to eq('id' => '123')
    end
  end
end
