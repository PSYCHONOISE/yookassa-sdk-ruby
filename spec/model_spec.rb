# frozen_string_literal: true

RSpec.describe 'domain models' do
  describe YooKassa::Amount do
    it 'stores value as a BigDecimal rounded to 2 decimal places' do
      amount = described_class.new(value: 10, currency: 'RUB')

      expect(amount.value).to be_a(BigDecimal)
      expect(amount.to_h[:value]).to eq('10.00')
    end
  end

  describe YooKassa::ReceiptData do
    it 'exposes email/phone convenience accessors backed by the customer' do
      receipt = described_class.new(items: [{ description: 'Item', quantity: 1, amount: { value: '1.00', currency: 'RUB' }, vat_code: 1 }])
      receipt.email = 'a@b.com'

      expect(receipt.customer.email).to eq('a@b.com')
      expect(receipt.email).to eq('a@b.com')
      expect(receipt.has_items?).to eq(true)
    end
  end

  describe YooKassa::WebhookNotification do
    it 'parses a payment.succeeded event into a PaymentResponse' do
      notification = described_class.new(
        'type' => 'notification',
        'event' => 'payment.succeeded',
        'object' => { 'id' => 'pay-1', 'status' => 'succeeded', 'amount' => { 'value' => '10.00', 'currency' => 'RUB' } }
      )

      expect(notification.event).to eq('payment.succeeded')
      expect(notification.object).to be_a(YooKassa::PaymentResponse)
      expect(notification.object.id).to eq('pay-1')
      expect(notification.object.amount.value).to eq(BigDecimal('10.00'))
    end

    it 'parses a refund.succeeded event into a RefundResponse' do
      notification = described_class.new(
        'type' => 'notification',
        'event' => 'refund.succeeded',
        'object' => { 'id' => 'ref-1', 'status' => 'succeeded', 'amount' => { 'value' => '5.00', 'currency' => 'RUB' } }
      )

      expect(notification.object).to be_a(YooKassa::RefundResponse)
      expect(notification.object.id).to eq('ref-1')
    end

    it 'parses a payout.succeeded event into a PayoutResponse' do
      notification = described_class.new(
        'type' => 'notification',
        'event' => 'payout.succeeded',
        'object' => { 'id' => 'po-1', 'status' => 'succeeded' }
      )

      expect(notification.object).to be_a(YooKassa::PayoutResponse)
    end

    it 'parses a deal.closed event into a DealResponse' do
      notification = described_class.new(
        'type' => 'notification',
        'event' => 'deal.closed',
        'object' => { 'id' => 'deal-1', 'status' => 'closed' }
      )

      expect(notification.object).to be_a(YooKassa::DealResponse)
    end

    it 'raises when object is empty' do
      expect do
        described_class.new('type' => 'notification', 'event' => 'payment.succeeded', 'object' => {})
      end.to raise_error(ArgumentError)
    end
  end
end
