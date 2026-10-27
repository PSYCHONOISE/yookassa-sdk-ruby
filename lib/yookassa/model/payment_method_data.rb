# frozen_string_literal: true

module YooKassa
  # Generic payment method data object (both request and response variants).
  #
  # The Python SDK has a dedicated class per payment method
  # (bank_card, yoo_money, sberbank, qiwi, webmoney, alfabank, tinkoff_bank,
  # mobile_balance, cash, installments, sbp, b2b_sberbank, google_pay,
  # apple_pay, wechat, psb, ...). This Ruby port models all of them with a
  # single class keyed by `type`, with every other documented field accepted
  # as a pass-through attribute (e.g. `card`, `account_number`, `phone`,
  # `payment_purpose`, `vat_data`, `payer_bank_details`, ...). Nested Hash
  # values (like `card`) are exposed as YooKassa::GenericObject so they can
  # still be accessed with dotted attribute syntax.
  class PaymentMethodData < BaseObject
    attribute :type, :id, :saved, :title

    def type=(value)
      @type = value&.to_s
    end
  end
end
