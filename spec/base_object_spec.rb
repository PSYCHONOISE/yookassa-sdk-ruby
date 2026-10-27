# frozen_string_literal: true

RSpec.describe YooKassa::BaseObject do
  describe '#to_h' do
    it 'omits nil attributes' do
      recipient = YooKassa::Recipient.new(account_id: '123')

      expect(recipient.to_h).to eq(account_id: '123')
    end

    it 'recursively serializes nested BaseObject attributes' do
      amount = YooKassa::Amount.new(value: '10.00', currency: 'RUB')
      settlement = YooKassa::Settlement.new(type: 'cashless', amount: amount)

      expect(settlement.to_h).to eq(type: 'cashless', amount: { value: '10.00', currency: 'RUB' })
    end

    it 'recursively serializes arrays of nested BaseObject attributes' do
      deal = YooKassa::PaymentDealInfo.new(id: 'deal-1', settlements: [{ type: 'payout', amount: { value: '5.00', currency: 'RUB' } }])

      expect(deal.to_h).to eq(
        id: 'deal-1',
        settlements: [{ type: 'payout', amount: { value: '5.00', currency: 'RUB' } }]
      )
    end
  end

  describe 'generic pass-through attributes' do
    it 'accepts and serializes fields that are not explicitly declared' do
      confirmation = YooKassa::Confirmation.new(type: 'redirect', return_url: 'https://example.com', enforce: true)

      expect(confirmation.type).to eq('redirect')
      expect(confirmation.return_url).to eq('https://example.com')
      expect(confirmation.enforce).to eq(true)
      expect(confirmation.to_h).to eq(type: 'redirect', return_url: 'https://example.com', enforce: true)
    end

    it 'wraps nested Hash values of pass-through attributes in a GenericObject' do
      payment_method = YooKassa::PaymentMethodData.new(type: 'bank_card', card: { first6: '555555', last4: '4444' })

      expect(payment_method.card).to be_a(YooKassa::GenericObject)
      expect(payment_method.card.first6).to eq('555555')
      expect(payment_method.to_h).to eq(type: 'bank_card', card: { first6: '555555', last4: '4444' })
    end
  end

  describe '.new' do
    it 'raises TypeError when given something other than a Hash' do
      expect { YooKassa::Recipient.new('not-a-hash') }.to raise_error(TypeError)
    end
  end
end
