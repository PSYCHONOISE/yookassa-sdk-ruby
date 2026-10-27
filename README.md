# YooKassa API Ruby Client Library

Russian | [English](README.en.md)

Клиент для работы с платежами по [API ЮKassa](https://yookassa.ru/developers/api).
Подходит тем, у кого способ подключения к ЮKassa называется API.

Это Ruby-реализация, построенная как idiomatic-аналог официального
[yookassa-sdk-python](https://github.com/yoomoney/yookassa-sdk-python) — с тем же
набором возможностей (платежи, возвраты, чеки, выплаты, сделки, вебхуки), но в стиле Ruby.

## Требования

1. Ruby >= 2.7, включая Ruby 4.x (MRI), или JRuby >= 9.4 — библиотека написана на чистом Ruby,
   без C-расширений, и покрыта тестами на всех этих версиях в CI
2. Bundler / RubyGems

## Установка

### С помощью gem install

```bash
gem install yookassa
```

### С помощью Bundler

Добавьте в `Gemfile`:

```ruby
gem 'yookassa'
```

и выполните:

```bash
bundle install
```

## Начало работы

1. Подключите библиотеку:

```ruby
require 'yookassa'
```

2. Настройте данные для конфигурации:

```ruby
require 'yookassa'

YooKassa::Configuration.configure('<Идентификатор магазина>', '<Секретный ключ>')
```

или через OAuth:

```ruby
require 'yookassa'

YooKassa::Configuration.configure_auth_token('<Oauth Token>')
```

Если вы согласны участвовать в развитии SDK, вы можете передать данные о вашем фреймворке, CMS или модуле:

```ruby
require 'yookassa'

YooKassa::Configuration.configure('<Идентификатор магазина>', '<Секретный ключ>')
YooKassa::Configuration.configure_user_agent(
  framework: YooKassa::Version.new('Rails', '7.1.0'),
  cms: YooKassa::Version.new('Spree', '4.6.0'),
  module: YooKassa::Version.new('Y.CMS', '0.0.1')
)
```

3. Вызовите нужный метод API. [Подробнее в документации к API ЮKassa](https://yookassa.ru/developers/api)

## Примеры использования SDK

#### [Настройки SDK API ЮKassa](docs/examples/01-configuration.md)
* [Аутентификация](docs/examples/01-configuration.md#Аутентификация)
* [Статистические данные об используемом окружении](docs/examples/01-configuration.md#Статистические-данные-об-используемом-окружении)
* [Получение информации о магазине](docs/examples/01-configuration.md#Получение-информации-о-магазине)
* [Работа с Webhook](docs/examples/01-configuration.md#Работа-с-Webhook)
* [Входящие уведомления](docs/examples/01-configuration.md#Входящие-уведомления)

#### [Работа с платежами](docs/examples/02-payments.md)
* [Запрос на создание платежа](docs/examples/02-payments.md#Запрос-на-создание-платежа)
* [Запрос на создание платежа через билдер](docs/examples/02-payments.md#Запрос-на-создание-платежа-через-билдер)
* [Запрос на частичное подтверждение платежа](docs/examples/02-payments.md#Запрос-на-частичное-подтверждение-платежа)
* [Запрос на отмену незавершенного платежа](docs/examples/02-payments.md#Запрос-на-отмену-незавершенного-платежа)
* [Получить информацию о платеже](docs/examples/02-payments.md#Получить-информацию-о-платеже)
* [Получить список платежей с фильтрацией](docs/examples/02-payments.md#Получить-список-платежей-с-фильтрацией)

#### [Работа с возвратами](docs/examples/03-refunds.md)
* [Запрос на создание возврата](docs/examples/03-refunds.md#Запрос-на-создание-возврата)
* [Запрос на создание возврата через билдер](docs/examples/03-refunds.md#Запрос-на-создание-возврата-через-билдер)
* [Получить информацию о возврате](docs/examples/03-refunds.md#Получить-информацию-о-возврате)
* [Получить список возвратов с фильтрацией](docs/examples/03-refunds.md#Получить-список-возвратов-с-фильтрацией)

#### [Работа с чеками](docs/examples/04-receipts.md)
* [Запрос на создание чека](docs/examples/04-receipts.md#Запрос-на-создание-чека)
* [Запрос на создание чека через билдер](docs/examples/04-receipts.md#Запрос-на-создание-чека-через-билдер)
* [Получить информацию о чеке](docs/examples/04-receipts.md#Получить-информацию-о-чеке)
* [Получить список чеков с фильтрацией](docs/examples/04-receipts.md#Получить-список-чеков-с-фильтрацией)

#### [Работа со сделками](docs/examples/05-deals.md)
* [Запрос на создание сделки](docs/examples/05-deals.md#Запрос-на-создание-сделки)
* [Запрос на создание сделки через билдер](docs/examples/05-deals.md#Запрос-на-создание-сделки-через-билдер)
* [Получить информацию о сделке](docs/examples/05-deals.md#Получить-информацию-о-сделке)
* [Получить список сделок с фильтрацией](docs/examples/05-deals.md#Получить-список-сделок-с-фильтрацией)

#### [Работа с выплатами](docs/examples/06-payouts.md)
* [Запрос на создание выплаты](docs/examples/06-payouts.md#Запрос-на-создание-выплаты)
* [Запрос на создание выплаты через билдер](docs/examples/06-payouts.md#Запрос-на-создание-выплаты-через-билдер)
* [Получить информацию о выплате](docs/examples/06-payouts.md#Получить-информацию-о-выплате)

## Быстрые примеры

### Платежи

Создание платежа через Hash:

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
    description: 'Заказ №72'
  },
  SecureRandom.uuid
)

puts response.id
puts response.status
puts response.confirmation.confirmation_url
```

Создание платежа через билдер:

```ruby
request = YooKassa::PaymentRequestBuilder.new
                                          .set_amount(value: '2.00', currency: 'RUB')
                                          .set_confirmation(type: 'redirect', return_url: 'https://www.merchant-website.com/return_url')
                                          .set_capture(true)
                                          .set_description('Заказ №72')
                                          .build

response = YooKassa::Payment.create(request)
```

Подтверждение платежа:

```ruby
response = YooKassa::Payment.capture(payment_id, { amount: { value: '2.00', currency: 'RUB' } })
```

Отмена платежа:

```ruby
response = YooKassa::Payment.cancel(payment_id)
```

Получение информации о платеже:

```ruby
response = YooKassa::Payment.find_one(payment_id)
```

Получение списка платежей с фильтрацией:

```ruby
response = YooKassa::Payment.list(limit: 10, status: 'succeeded')
```

### Возвраты

```ruby
response = YooKassa::Refund.create(
  payment_id: payment_id,
  amount: { value: '2.00', currency: 'RUB' }
)
```

через билдер:

```ruby
request = YooKassa::RefundRequestBuilder.new
                                         .set_payment_id(payment_id)
                                         .set_amount(value: '2.00', currency: 'RUB')
                                         .build

response = YooKassa::Refund.create(request)
```

Получение информации о возврате:

```ruby
response = YooKassa::Refund.find_one(refund_id)
```

Получение списка возвратов с фильтрацией:

```ruby
response = YooKassa::Refund.list(payment_id: payment_id)
```

### Чеки

```ruby
response = YooKassa::Receipt.create(
  type: 'payment',
  send: true,
  customer: { email: 'test@test.ru' },
  items: [
    {
      description: 'Наушники',
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

через билдер:

```ruby
request = YooKassa::ReceiptRequestBuilder.new
                                          .set_type('payment')
                                          .set_send(true)
                                          .set_customer(email: 'test@test.ru')
                                          .set_items([{ description: 'Наушники', quantity: '1', amount: { value: '2.00', currency: 'RUB' }, vat_code: 1 }])
                                          .set_settlements([{ type: 'cashless', amount: { value: '2.00', currency: 'RUB' } }])
                                          .set_payment_id(payment_id)
                                          .build

response = YooKassa::Receipt.create(request)
```

Получение информации о чеке / списка чеков:

```ruby
response = YooKassa::Receipt.find_one(receipt_id)
response = YooKassa::Receipt.list(limit: 10)
```

### Выплаты

```ruby
response = YooKassa::Payout.create(
  amount: { value: '2.00', currency: 'RUB' },
  payout_destination_data: {
    type: 'bank_card',
    card: { number: '5555555555554444' }
  }
)
```

через билдер:

```ruby
request = YooKassa::PayoutRequestBuilder.new
                                         .set_amount(value: '2.00', currency: 'RUB')
                                         .set_payout_destination_data(type: 'bank_card', card: { number: '5555555555554444' })
                                         .build

response = YooKassa::Payout.create(request)
```

Получение информации о выплате:

```ruby
response = YooKassa::Payout.find_one(payout_id)
```

### Работа со сделками (Safe Deal)

```ruby
response = YooKassa::Deal.create(type: 'safe_deal', fee_moment: 'payment_succeeded')
```

через билдер:

```ruby
request = YooKassa::DealRequestBuilder.new
                                       .set_type('safe_deal')
                                       .set_fee_moment('payment_succeeded')
                                       .build

response = YooKassa::Deal.create(request)
```

Получение информации о сделке / списка сделок:

```ruby
response = YooKassa::Deal.find_one(deal_id)
response = YooKassa::Deal.list(limit: 10)
```

### Работа с Webhook

Подписка на уведомление:

```ruby
response = YooKassa::Webhook.add(event: 'payment.succeeded', url: 'https://merchant-website.com/notifications')
```

Список подписок:

```ruby
response = YooKassa::Webhook.list
```

Удаление подписки:

```ruby
YooKassa::Webhook.remove(webhook_id)
```

### Входящие уведомления

Если магазин подписан на уведомления, ЮKassa отправляет HTTP-запрос с данными об изменении статуса
платежа, возврата, выплаты или сделки. Разберите тело запроса следующим образом:

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

### Получение информации о магазине

```ruby
settings = YooKassa::Settings.get_account_settings
```

## Обработка ошибок

Все ошибки API — подклассы `YooKassa::ApiError`:

```ruby
begin
  YooKassa::Payment.find_one('unknown-id')
rescue YooKassa::NotFoundError => e
  puts e.response_body
end
```

## Особенности этой реализации по сравнению с Python SDK

* Платёжные методы (`payment_method_data`/`payment_method`), способы подтверждения (`confirmation`)
  и способы выплат (`payout_destination_data`) реализованы одним гибким классом с атрибутом `type`
  и произвольными полями "по требованию", а не отдельным Ruby-классом на каждый документированный
  вариант (`bank_card`, `yoo_money`, `sbp`, `b2b_sberbank`, `apple_pay`, `google_pay` и т.д.) — как в
  Python SDK. Любое документированное поле всё равно доступно через точечный доступ
  (`payment.payment_method.card.last4`).
* HTTP-запросы выполняются через `Net::HTTP` из стандартной библиотеки Ruby — без внешних
  HTTP-зависимостей (аналогично тому, как Python SDK использует `requests`, потому что в Python
  нет удобного стандартного HTTP-клиента).

## Тесты

```bash
bundle install
bundle exec rspec
```

## Лицензия

MIT License. См. файл [LICENSE](LICENSE).
