# YooKassa API Ruby Client Library

English | [Russian](README.md)

A client library for working with payments through the [YooKassa API](https://yookassa.ru/en/developers/api).
A good fit if your integration method with YooKassa is called "API".

This is a Ruby implementation built as an idiomatic counterpart to the official
[yookassa-sdk-python](https://github.com/yoomoney/yookassa-sdk-python) — the same feature set
(payments, refunds, receipts, payouts, deals, webhooks), written in Ruby style.

## Requirements

1. Ruby >= 2.7, including Ruby 4.x (MRI), or JRuby >= 9.4 — the library is pure Ruby with no
   C extensions, and is tested against all of these versions in CI
2. Bundler / RubyGems

## Installation

### Using gem install

```bash
gem install yookassa
```

### Using Bundler

Add to your `Gemfile`:

```ruby
gem 'yookassa'
```

then run:

```bash
bundle install
```

## Getting started

1. Require the library:

```ruby
require 'yookassa'
```

2. Configure credentials:

```ruby
require 'yookassa'

YooKassa::Configuration.configure('<Shop id>', '<Secret key>')
```

or using OAuth:

```ruby
require 'yookassa'

YooKassa::Configuration.configure_auth_token('<Oauth Token>')
```

If you would like to help improve the SDK, you can pass information about your framework, CMS or module:

```ruby
require 'yookassa'

YooKassa::Configuration.configure('<Shop id>', '<Secret key>')
YooKassa::Configuration.configure_user_agent(
  framework: YooKassa::Version.new('Rails', '7.1.0'),
  cms: YooKassa::Version.new('Spree', '4.6.0'),
  module: YooKassa::Version.new('Y.CMS', '0.0.1')
)
```

3. Call the API method you need. [See the YooKassa API reference for details](https://yookassa.ru/en/developers/api)

## Usage examples

#### [YooKassa SDK Settings](docs/examples/01-configuration.md)
* [Authentication](docs/examples/01-configuration.md#Аутентификация)
* [Statistics about the environment used](docs/examples/01-configuration.md#Статистические-данные-об-используемом-окружении)
* [Getting information about the store](docs/examples/01-configuration.md#Получение-информации-о-магазине)
* [Working with Webhook](docs/examples/01-configuration.md#Работа-с-Webhook)
* [Notifications](docs/examples/01-configuration.md#Входящие-уведомления)

#### [Working with payments](docs/examples/02-payments.md)
* [Request to create a payment](docs/examples/02-payments.md#Запрос-на-создание-платежа)
* [Request to create a payment via the builder](docs/examples/02-payments.md#Запрос-на-создание-платежа-через-билдер)
* [Request for partial payment confirmation](docs/examples/02-payments.md#Запрос-на-частичное-подтверждение-платежа)
* [Request to cancel an incomplete payment](docs/examples/02-payments.md#Запрос-на-отмену-незавершенного-платежа)
* [Get payment information](docs/examples/02-payments.md#Получить-информацию-о-платеже)
* [Get a list of payments with filtering](docs/examples/02-payments.md#Получить-список-платежей-с-фильтрацией)

#### [Working with refunds](docs/examples/03-refunds.md)
* [Request to create a refund](docs/examples/03-refunds.md#Запрос-на-создание-возврата)
* [Request to create a refund via the builder](docs/examples/03-refunds.md#Запрос-на-создание-возврата-через-билдер)
* [Get refund information](docs/examples/03-refunds.md#Получить-информацию-о-возврате)
* [Get a list of refunds with filtering](docs/examples/03-refunds.md#Получить-список-возвратов-с-фильтрацией)

#### [Working with receipts](docs/examples/04-receipts.md)
* [Request to create a receipt](docs/examples/04-receipts.md#Запрос-на-создание-чека)
* [Request to create a receipt via the builder](docs/examples/04-receipts.md#Запрос-на-создание-чека-через-билдер)
* [Get information about the receipt](docs/examples/04-receipts.md#Получить-информацию-о-чеке)
* [Get a list of receipts with filtering](docs/examples/04-receipts.md#Получить-список-чеков-с-фильтрацией)

#### [Working with deals](docs/examples/05-deals.md)
* [Request to create a deal](docs/examples/05-deals.md#Запрос-на-создание-сделки)
* [Request to create a deal via the builder](docs/examples/05-deals.md#Запрос-на-создание-сделки-через-билдер)
* [Get information about the deal](docs/examples/05-deals.md#Получить-информацию-о-сделке)
* [Get a list of deals with filtering](docs/examples/05-deals.md#Получить-список-сделок-с-фильтрацией)

#### [Working with payouts](docs/examples/06-payouts.md)
* [Request to create a payout](docs/examples/06-payouts.md#Запрос-на-создание-выплаты)
* [Request to create a payout via the builder](docs/examples/06-payouts.md#Запрос-на-создание-выплаты-через-билдер)
* [Get information about the payout](docs/examples/06-payouts.md#Получить-информацию-о-выплате)

> The linked pages are in Russian, mirroring the upstream Python SDK's own `docs/examples`.

## Quick examples

### Payments

Creating a payment from a Hash:

```ruby
response = YooKassa::Payment.create(
  {
    amount: {
      value: '2.00',
      currency: 'RUB'
    },
    confirmation: {
      type: 'redirect',
      return_url: 'https://www.merchant-website.com/return_url'
    },
    capture: true,
    description: 'Order #72'
  },
  SecureRandom.uuid
)

puts response.id
puts response.status
puts response.confirmation.confirmation_url
```

Creating a payment with the builder:

```ruby
request = YooKassa::PaymentRequestBuilder.new
                                          .set_amount(value: '2.00', currency: 'RUB')
                                          .set_confirmation(type: 'redirect', return_url: 'https://www.merchant-website.com/return_url')
                                          .set_capture(true)
                                          .set_description('Order #72')
                                          .build

response = YooKassa::Payment.create(request)
```

Capturing a payment:

```ruby
response = YooKassa::Payment.capture(payment_id, { amount: { value: '2.00', currency: 'RUB' } })
```

Canceling a payment:

```ruby
response = YooKassa::Payment.cancel(payment_id)
```

Getting information about a payment:

```ruby
response = YooKassa::Payment.find_one(payment_id)
```

Getting a filtered list of payments:

```ruby
response = YooKassa::Payment.list(limit: 10, status: 'succeeded')
```

### Refunds

```ruby
response = YooKassa::Refund.create(
  payment_id: payment_id,
  amount: { value: '2.00', currency: 'RUB' }
)
```

with the builder:

```ruby
request = YooKassa::RefundRequestBuilder.new
                                         .set_payment_id(payment_id)
                                         .set_amount(value: '2.00', currency: 'RUB')
                                         .build

response = YooKassa::Refund.create(request)
```

Getting information about a refund:

```ruby
response = YooKassa::Refund.find_one(refund_id)
```

Getting a filtered list of refunds:

```ruby
response = YooKassa::Refund.list(payment_id: payment_id)
```

### Receipts

```ruby
response = YooKassa::Receipt.create(
  type: 'payment',
  send: true,
  customer: { email: 'test@test.ru' },
  items: [
    {
      description: 'Headphones',
      quantity: '1',
      amount: { value: '2.00', currency: 'RUB' },
      vat_code: 1
    }
  ],
  settlements: [
    { type: 'cashless', amount: { value: '2.00', currency: 'RUB' } }
  ],
  payment_id: payment_id
)
```

with the builder:

```ruby
request = YooKassa::ReceiptRequestBuilder.new
                                          .set_type('payment')
                                          .set_send(true)
                                          .set_customer(email: 'test@test.ru')
                                          .set_items([{ description: 'Headphones', quantity: '1', amount: { value: '2.00', currency: 'RUB' }, vat_code: 1 }])
                                          .set_settlements([{ type: 'cashless', amount: { value: '2.00', currency: 'RUB' } }])
                                          .set_payment_id(payment_id)
                                          .build

response = YooKassa::Receipt.create(request)
```

Getting a receipt / list of receipts:

```ruby
response = YooKassa::Receipt.find_one(receipt_id)
response = YooKassa::Receipt.list(limit: 10)
```

### Payouts

```ruby
response = YooKassa::Payout.create(
  amount: { value: '2.00', currency: 'RUB' },
  payout_destination_data: {
    type: 'bank_card',
    card: { number: '5555555555554444' }
  }
)
```

with the builder:

```ruby
request = YooKassa::PayoutRequestBuilder.new
                                         .set_amount(value: '2.00', currency: 'RUB')
                                         .set_payout_destination_data(type: 'bank_card', card: { number: '5555555555554444' })
                                         .build

response = YooKassa::Payout.create(request)
```

Getting information about a payout:

```ruby
response = YooKassa::Payout.find_one(payout_id)
```

### Deals (Safe Deal)

```ruby
response = YooKassa::Deal.create(type: 'safe_deal', fee_moment: 'payment_succeeded')
```

with the builder:

```ruby
request = YooKassa::DealRequestBuilder.new
                                       .set_type('safe_deal')
                                       .set_fee_moment('payment_succeeded')
                                       .build

response = YooKassa::Deal.create(request)
```

Getting a deal / list of deals:

```ruby
response = YooKassa::Deal.find_one(deal_id)
response = YooKassa::Deal.list(limit: 10)
```

### Webhooks

Subscribing to a notification:

```ruby
response = YooKassa::Webhook.add(event: 'payment.succeeded', url: 'https://merchant-website.com/notifications')
```

Listing subscriptions:

```ruby
response = YooKassa::Webhook.list
```

Removing a subscription:

```ruby
YooKassa::Webhook.remove(webhook_id)
```

### Incoming notifications

If your shop is subscribed to notifications, YooKassa sends an HTTP request with data about a
change in a payment's, refund's, payout's or deal's status. Parse the request body like this:

```ruby
notification = YooKassa::WebhookNotification.new(JSON.parse(request_body))

case notification.event
when YooKassa::WebhookNotificationEventType::PAYMENT_SUCCEEDED
  payment = notification.object
  puts payment.id
when YooKassa::WebhookNotificationEventType::REFUND_SUCCEEDED
  refund = notification.object
  puts refund.id
end
```

### Shop info

```ruby
settings = YooKassa::Settings.get_account_settings
```

## Error handling

All API errors are subclasses of `YooKassa::ApiError`:

```ruby
begin
  YooKassa::Payment.find_one('unknown-id')
rescue YooKassa::NotFoundError => e
  puts e.response_body
end
```

## Differences from the Python SDK

* Payment method data (`payment_method_data`/`payment_method`), confirmation types (`confirmation`)
  and payout destinations (`payout_destination_data`) are modeled with one flexible class driven by
  a `type` attribute plus arbitrary pass-through fields, instead of a dedicated Ruby class per
  documented variant (`bank_card`, `yoo_money`, `sbp`, `b2b_sberbank`, `apple_pay`, `google_pay`, etc.)
  like the Python SDK does. Every documented field is still reachable through dotted attribute
  access (`payment.payment_method.card.last4`).
* HTTP requests are made with Ruby's standard library `Net::HTTP` - no external HTTP dependency
  (mirroring how the Python SDK depends on `requests` only because Python's standard library has no
  convenient HTTP client).

## Tests

```bash
bundle install
bundle exec rspec
```

## License

MIT License. See the [LICENSE](LICENSE) file.
