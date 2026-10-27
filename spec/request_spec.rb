# frozen_string_literal: true

RSpec.describe 'request objects and builders' do
  describe YooKassa::PaymentRequestBuilder do
    it 'builds a PaymentRequest via chained set_ methods' do
      request = described_class.new
                                .set_amount(value: '10.00', currency: 'RUB')
                                .set_description('Order #1')
                                .set_confirmation(type: 'redirect', return_url: 'https://merchant.test/return')
                                .set_capture(true)
                                .set_metadata('order_id' => '1')
                                .build

      expect(request).to be_a(YooKassa::PaymentRequest)
      expect(request.to_h).to eq(
        amount: { value: '10.00', currency: 'RUB' },
        description: 'Order #1',
        confirmation: { type: 'redirect', return_url: 'https://merchant.test/return' },
        capture: true,
        metadata: { 'order_id' => '1' }
      )
    end

    it 'validates that an amount is present' do
      request = described_class.new.set_description('no amount').build

      expect { request.validate }.to raise_error(ArgumentError, /amount/i)
    end

    it 'validates that the amount value is positive' do
      request = described_class.new.set_amount(value: '0.00', currency: 'RUB').build

      expect { request.validate }.to raise_error(ArgumentError, /Invalid payment amount value/)
    end

    it 'rejects both payment_token and payment_method_id being set' do
      request = described_class.new
                                .set_amount(value: '1.00', currency: 'RUB')
                                .set_payment_token('tok_1')
                                .set_payment_method_id('pm_1')
                                .build

      expect { request.validate }.to raise_error(ArgumentError, /payment_token and payment_method_id/)
    end
  end

  describe YooKassa::CapturePaymentBuilder do
    it 'builds a CapturePaymentRequest' do
      request = described_class.new.set_amount(value: '10.00', currency: 'RUB').build

      expect(request).to be_a(YooKassa::CapturePaymentRequest)
      expect(request.to_h).to eq(amount: { value: '10.00', currency: 'RUB' })
    end
  end

  describe YooKassa::RefundRequestBuilder do
    it 'builds a RefundRequest' do
      request = described_class.new
                                .set_payment_id('2' * 36)
                                .set_amount(value: '5.00', currency: 'RUB')
                                .build

      expect(request).to be_a(YooKassa::RefundRequest)
      expect(request.payment_id).to eq('2' * 36)
      expect { request.validate }.not_to raise_error
    end

    it 'validates payment_id length' do
      expect { described_class.new.set_payment_id('too-short').build }.to raise_error(ArgumentError)
    end
  end

  describe YooKassa::ReceiptRequestBuilder do
    it 'builds a ReceiptRequest and validates required fields' do
      request = described_class.new
                                .set_type('payment')
                                .set_send(true)
                                .set_customer(email: 'a@b.com')
                                .set_items([{ description: 'Item', quantity: 1, amount: { value: '1.00', currency: 'RUB' }, vat_code: 1 }])
                                .set_settlements([{ type: 'cashless', amount: { value: '1.00', currency: 'RUB' } }])
                                .set_payment_id('pay-1')
                                .build

      expect { request.validate }.not_to raise_error
      expect(request.to_h[:type]).to eq('payment')
      expect(request.to_h[:items].first[:description]).to eq('Item')
    end

    it 'raises when neither email nor phone is set on the customer' do
      request = described_class.new
                                .set_type('payment')
                                .set_send(true)
                                .set_customer({})
                                .set_items([{ description: 'Item', quantity: 1, amount: { value: '1.00', currency: 'RUB' }, vat_code: 1 }])
                                .set_settlements([{ type: 'cashless', amount: { value: '1.00', currency: 'RUB' } }])
                                .set_payment_id('pay-1')
                                .build

      expect { request.validate }.to raise_error(ArgumentError, /email and phone/)
    end
  end

  describe YooKassa::PayoutRequestBuilder do
    it 'builds a PayoutRequest' do
      request = described_class.new
                                .set_amount(value: '100.00', currency: 'RUB')
                                .set_payout_destination_data(type: 'bank_card', card: { number: '5555555555554444' })
                                .build

      expect(request).to be_a(YooKassa::PayoutRequest)
      expect { request.validate }.not_to raise_error
      expect(request.payout_destination_data.type).to eq('bank_card')
    end

    it 'rejects setting neither payout_token nor payout_destination_data' do
      request = described_class.new.set_amount(value: '1.00', currency: 'RUB').build

      expect { request.validate }.to raise_error(ArgumentError)
    end
  end

  describe YooKassa::DealRequestBuilder do
    it 'builds and validates a DealRequest' do
      request = described_class.new.set_type('safe_deal').set_fee_moment('payment_succeeded').build

      expect { request.validate }.not_to raise_error
      expect(request.to_h).to eq(type: 'safe_deal', fee_moment: 'payment_succeeded')
    end

    it 'requires type and fee_moment' do
      expect { described_class.new.build.validate }.to raise_error(ArgumentError)
    end
  end

  describe YooKassa::WebhookRequest do
    it 'stores event and url' do
      request = described_class.new(event: 'payment.succeeded', url: 'https://example.com/hook')

      expect(request.to_h).to eq(event: 'payment.succeeded', url: 'https://example.com/hook')
    end
  end
end
