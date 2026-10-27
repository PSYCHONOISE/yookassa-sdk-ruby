# frozen_string_literal: true

RSpec.describe 'response objects' do
  describe YooKassa::PaymentResponse do
    it 'wraps nested amount/confirmation/payment_method/recipient hashes into typed objects' do
      response = described_class.new(
        'id' => 'pay-1',
        'status' => 'succeeded',
        'amount' => { 'value' => '10.00', 'currency' => 'RUB' },
        'confirmation' => { 'type' => 'redirect', 'confirmation_url' => 'https://pay.test/1' },
        'payment_method' => { 'type' => 'bank_card', 'id' => 'pm-1', 'saved' => false,
                               'card' => { 'first6' => '555555', 'last4' => '4444' } },
        'recipient' => { 'account_id' => '1', 'gateway_id' => '2' },
        'paid' => true
      )

      expect(response.amount).to be_a(YooKassa::Amount)
      expect(response.amount.value).to eq(BigDecimal('10.00'))
      expect(response.confirmation).to be_a(YooKassa::Confirmation)
      expect(response.confirmation.confirmation_url).to eq('https://pay.test/1')
      expect(response.payment_method).to be_a(YooKassa::PaymentMethodData)
      expect(response.payment_method.card.last4).to eq('4444')
      expect(response.recipient).to be_a(YooKassa::Recipient)
      expect(response.paid).to eq(true)
    end
  end

  describe YooKassa::PaymentListResponse do
    it 'wraps items into PaymentResponse objects and exposes next_cursor' do
      response = described_class.new(
        'type' => 'list',
        'items' => [{ 'id' => 'pay-1' }, { 'id' => 'pay-2' }],
        'next_cursor' => 'abc'
      )

      expect(response.items).to all(be_a(YooKassa::PaymentResponse))
      expect(response.items.map(&:id)).to eq(%w[pay-1 pay-2])
      expect(response.next_cursor).to eq('abc')
    end
  end

  describe YooKassa::RefundListResponse do
    it 'wraps items into RefundResponse objects' do
      response = described_class.new('items' => [{ 'id' => 'ref-1' }])

      expect(response.items.first).to be_a(YooKassa::RefundResponse)
    end
  end

  describe YooKassa::ReceiptListResponse do
    it 'wraps items into ReceiptResponse objects' do
      response = described_class.new('items' => [{ 'id' => 'rec-1' }])

      expect(response.items.first).to be_a(YooKassa::ReceiptResponse)
    end
  end

  describe YooKassa::DealListResponse do
    it 'wraps items into DealResponse objects' do
      response = described_class.new('items' => [{ 'id' => 'deal-1' }])

      expect(response.items.first).to be_a(YooKassa::DealResponse)
    end
  end

  describe YooKassa::WebhookList do
    it 'wraps items into WebhookResponse objects' do
      response = described_class.new('items' => [{ 'id' => 'wh-1', 'event' => 'payment.succeeded', 'url' => 'https://x' }])

      expect(response.items.first).to be_a(YooKassa::WebhookResponse)
      expect(response.items.first.event).to eq('payment.succeeded')
    end
  end
end
