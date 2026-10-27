# frozen_string_literal: true

module YooKassa
  # HTTP method verbs used internally by YooKassa::ApiClient.
  module HttpVerb
    GET = 'get'
    POST = 'post'
    PUT = 'put'
    PATCH = 'patch'
    HEAD = 'head'
    OPTIONS = 'options'
    DELETE = 'delete'
  end

  # Confirmation types. See YooKassa::Model::Confirmation.
  module ConfirmationType
    EMBEDDED = 'embedded'
    EXTERNAL = 'external'
    REDIRECT = 'redirect'
    QR = 'qr'
    MOBILE_APPLICATION = 'mobile_application'
  end

  # payment_method / payment_method_data `type` values.
  module PaymentMethodType
    YOO_MONEY = 'yoo_money'
    BANK_CARD = 'bank_card'
    SBERBANK = 'sberbank'
    CASH = 'cash'
    MOBILE_BALANCE = 'mobile_balance'
    PSB = 'psb'
    QIWI = 'qiwi'
    WEBMONEY = 'webmoney'
    ALFABANK = 'alfabank'
    APPLEPAY = 'apple_pay'
    GOOGLE_PAY = 'google_pay'
    INSTALMENTS = 'installments'
    B2B_SBERBANK = 'b2b_sberbank'
    TINKOFF_BANK = 'tinkoff_bank'
    WECHAT = 'wechat'
    SBP = 'sbp'
  end

  module ReceiptType
    PAYMENT = 'payment'
    REFUND = 'refund'
  end

  module ReceiptItemAgentType
    BANKING_PAYMENT_AGENT = 'banking_payment_agent'
    BANKING_PAYMENT_SUBAGENT = 'banking_payment_subagent'
    PAYMENT_AGENT = 'payment_agent'
    PAYMENT_SUBAGENT = 'payment_subagent'
    ATTORNEY = 'attorney'
    COMMISSIONER = 'commissioner'
    AGENT = 'agent'
  end

  module PaymentMode
    FULL_PREPAYMENT = 'full_prepayment'
    PARTIAL_PREPAYMENT = 'partial_prepayment'
    ADVANCE = 'advance'
    FULL_PAYMENT = 'full_payment'
    PARTIAL_PAYMENT = 'partial_payment'
    CREDIT = 'credit'
    CREDIT_PAYMENT = 'credit_payment'
  end

  module PaymentSubject
    COMMODITY = 'commodity'
    EXCISE = 'excise'
    JOB = 'job'
    SERVICE = 'service'
    GAMBLING_BET = 'gambling_bet'
    GAMBLING_PRIZE = 'gambling_prize'
    LOTTERY = 'lottery'
    LOTTERY_PRIZE = 'lottery_prize'
    INTELLECTUAL_ACTIVITY = 'intellectual_activity'
    PAYMENT = 'payment'
    AGENT_COMMISSION = 'agent_commission'
    COMPOSITE = 'composite'
    ANOTHER = 'another'
  end

  module Currency
    RUB = 'RUB'
    USD = 'USD'
    EUR = 'EUR'
    BYN = 'BYN'
    CNY = 'CNY'
    KZT = 'KZT'
    UAH = 'UAH'
  end

  module CardType
    MASTER_CARD = 'MasterCard'
    VISA = 'Visa'
    MIR = 'MIR'
    UNION_PAY = 'UnionPay'
    CUP = 'CUP'
    JCB = 'JCB'
    AMERICAN_EXPRESS = 'AmericanExpress'
    DINERS_CLUB = 'DinersClub'
    UNKNOWN = 'Unknown'
  end

  module CardSource
    APPLE_PAY = 'apple_pay'
    GOOGLE_PAY = 'google_pay'
  end

  module DealType
    SAFE_DEAL = 'safe_deal'
  end

  module DealStatus
    OPENED = 'opened'
    CLOSED = 'closed'
  end

  module FeeMoment
    PAYMENT_SUCCEEDED = 'payment_succeeded'
    DEAL_CLOSED = 'deal_closed'
  end

  module PayoutStatus
    PENDING = 'pending'
    SUCCEEDED = 'succeeded'
    CANCELED = 'canceled'
  end

  module SettlementType
    CASHLESS = 'cashless'
    PREPAYMENT = 'prepayment'
    POSTPAYMENT = 'postpayment'
    CONSIDERATION = 'consideration'
  end

  module SettlementPayoutType
    PAYOUT = 'payout'
  end

  module TransferStatus
    PENDING = 'pending'
    WAITING_FOR_CAPTURE = 'waiting_for_capture'
    SUCCEEDED = 'succeeded'
    CANCELED = 'canceled'
  end

  module CancellationDetailsPartyCode
    MERCHANT = 'merchant'
    YOO_KASSA = 'yoo_kassa'
    PAYMENT_NETWORK = 'payment_network'
  end

  module CancellationDetailsReasonCode
    THREE_D_SECURE_FAILED = '3d_secure_failed'
    CALL_ISSUER = 'call_issuer'
    CARD_EXPIRED = 'card_expired'
    COUNTRY_FORBIDDEN = 'country_forbidden'
    FRAUD_SUSPECTED = 'fraud_suspected'
    GENERAL_DECLINE = 'general_decline'
    IDENTIFICATION_REQUIRED = 'identification_required'
    INSUFFICIENT_FUNDS = 'insufficient_funds'
    INVALID_CARD_NUMBER = 'invalid_card_number'
    INVALID_CSC = 'invalid_csc'
    ISSUER_UNAVAILABLE = 'issuer_unavailable'
    PAYMENT_METHOD_LIMIT_EXCEEDED = 'payment_method_limit_exceeded'
    PAYMENT_METHOD_RESTRICTED = 'payment_method_restricted'
    PERMISSION_REVOKED = 'permission_revoked'
    INTERNAL_TIMEOUT = 'internal_timeout'
    CANCELED_BY_MERCHANT = 'canceled_by_merchant'
    PAYMENT_EXPIRED = 'payment_expired'
    EXPIRED_ON_CONFIRMATION = 'expired_on_confirmation'
    EXPIRED_ON_CAPTURE = 'expired_on_capture'
  end

  module PayoutCancellationDetailsReasonCode
    FRAUD_SUSPECTED = 'fraud_suspected'
    GENERAL_DECLINE = 'general_decline'
    ONE_TIME_LIMIT_EXCEEDED = 'one_time_limit_exceeded'
    PERIODIC_LIMIT_EXCEEDED = 'periodic_limit_exceeded'
    REJECTED_BY_PAYEE = 'rejected_by_payee'
  end

  module VatDataType
    CALCULATED = 'calculated'
    MIXED = 'mixed'
    UNTAXED = 'untaxed'
  end

  module VatDataRate
    RATE_7 = 7
    RATE_10 = 10
    RATE_18 = 18
    RATE_20 = 20
  end

  module WebhookNotificationType
    NOTIFICATION = 'notification'
  end

  module WebhookNotificationEventType
    PAYMENT_WAITING_FOR_CAPTURE = 'payment.waiting_for_capture'
    PAYMENT_SUCCEEDED = 'payment.succeeded'
    PAYMENT_CANCELED = 'payment.canceled'
    REFUND_SUCCEEDED = 'refund.succeeded'
    DEAL_CLOSED = 'deal.closed'
    PAYOUT_CANCELED = 'payout.canceled'
    PAYOUT_SUCCEEDED = 'payout.succeeded'
  end
end
