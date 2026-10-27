## Настройки SDK API ЮKassa

[Справочник API ЮKassa](https://yookassa.ru/developers/api)

С помощью этого SDK вы можете работать с онлайн-платежами: отправлять запросы на оплату,
сохранять платежную информацию для повторных списаний, совершать возвраты и многое другое.

* [Аутентификация](#Аутентификация)
* [Статистические данные об используемом окружении](#Статистические-данные-об-используемом-окружении)
* [Получение информации о магазине](#Получение-информации-о-магазине)
* [Работа с Webhook](#Работа-с-Webhook)
* [Входящие уведомления](#Входящие-уведомления)

---

### Аутентификация

Для работы с API необходимо прописать в конфигурации данные аутентификации. Существует два способа аутентификации:
- shopId + секретный ключ
- OAuth-токен. [Подробнее в документации к API](https://yookassa.ru/developers/partners-api/basics)

```ruby
require 'yookassa'

# shopId + секретный ключ
YooKassa::Configuration.configure('XXXXXX', 'test_XXXXXXXX')
# или OAuth-токен
YooKassa::Configuration.configure_auth_token('token-XXXXXXXX')
```

---

### Статистические данные об используемом окружении

Для поддержки качества, а также быстром реагировании на ошибки, SDK передает статистику в запросах к API ЮKassa.

По умолчанию SDK передает в запросах версию операционной системы, версию Ruby, а также версию SDK.
Но вы можете передать дополнительные данные об используемом фреймворке, CMS, а также модуле в CMS.

Например, это может выглядеть так:
```ruby
require 'yookassa'

YooKassa::Configuration.configure_user_agent(
  framework: YooKassa::Version.new('Rails', '7.1.0'),
  cms: YooKassa::Version.new('Spree', '4.6.0'),
  module: YooKassa::Version.new('Y.CMS', '0.0.1')
)
```

---

### Получение информации о магазине

После установки конфигурации можно проверить корректность данных, а также получить информацию о магазине.

```ruby
require 'yookassa'
require 'pp'

me = YooKassa::Settings.get_account_settings
pp me
```
В результате мы увидим примерно следующее (метод возвращает обычный Hash, полученный из JSON-ответа API):
```ruby
{
  "account_id" => "XXXXXX",
  "test" => true,
  "fiscalization_enabled" => true,
  "payment_methods" => ["yoo_money", "bank_card"],
  "status" => "enabled"
}
```
[Подробнее в документации к API](https://yookassa.ru/developers/api#me_object)

---

### Работа с Webhook

Если вы подключаетесь к API через OAuth-токен, то можете настроить получение уведомлений о смене статуса платежа или возврата.

Например, ЮKassa может сообщить, когда объект платежа, созданный в вашем приложении, перейдет в статус `waiting_for_capture`.

В данном примере мы устанавливаем вебхуки для succeeded и canceled уведомлений.
А так же проверяем, не установлены ли уже вебхуки. И если установлены на неверный адрес, удаляем.

```ruby
require 'yookassa'
require 'pp'

wh_url = 'https://merchant-site.ru/payment-notification'
need_webhook_list = [
  YooKassa::WebhookNotificationEventType::PAYMENT_SUCCEEDED,
  YooKassa::WebhookNotificationEventType::PAYMENT_CANCELED
]

wh_list = YooKassa::Webhook.list

need_webhook_list.each do |event|
  hook_is_set = false

  wh_list.items.each do |wh|
    next if wh.event != event

    if wh.url != wh_url
      YooKassa::Webhook.remove(wh.id)
    else
      hook_is_set = true
    end
  end

  YooKassa::Webhook.add({ 'event' => event, 'url' => wh_url }) unless hook_is_set
end

pp YooKassa::Webhook.list
```

В результате мы увидим примерно следующее:
```
#<YooKassa::WebhookList:0x00000001
 @items=
  [#<YooKassa::WebhookResponse:0x00000002
    @id="wh-52e51c6e-29a2-4a0d-800b-01cf022b5613",
    @event="payment.canceled",
    @url="https://merchant-site.ru/payment-notification">,
   #<YooKassa::WebhookResponse:0x00000003
    @id="wh-c331b3ee-fb65-428d-b008-1b837d9c4d93",
    @event="payment.succeeded",
    @url="https://merchant-site.ru/payment-notification">],
 @type="list">
```
[Подробнее в документации к API](https://yookassa.ru/developers/api#webhook)

### Входящие уведомления

Если вы хотите отслеживать состояние платежей и возвратов, вы можете подписаться на уведомления ([webhook](#Работа-с-Webhook), callback).

Уведомления пригодятся в тех случаях, когда объект API изменяется без вашего участия.
Например, если пользователю нужно подтвердить платеж, процесс оплаты может занять от нескольких минут до нескольких часов.
Вместо того чтобы всё это время периодически отправлять GET-запросы, чтобы узнать статус платежа, вы можете просто дожидаться уведомления от ЮKassa.

[Входящие уведомления в документации](https://yookassa.ru/developers/using-api/webhooks)

#### Использование

Как только произойдет событие, на которое вы подписались, на URL, который вы указали при настройке, придет уведомление.
В нем будут все данные об объекте на момент, когда произошло событие.

Вам нужно подтвердить, что вы получили уведомление. Для этого ответьте HTTP-кодом 200. ЮKassa проигнорирует всё,
что будет находиться в теле или заголовках ответа. Ответы с любыми другими HTTP-кодами будут считаться невалидными,
и ЮKassa продолжит доставлять уведомление в течение 24 часов, начиная с момента, когда событие произошло.

#### Пример обработки уведомления с помощью SDK

Пример для Rails-контроллера (но подойдёт для любого Rack-приложения — Sinatra, Hanami и т. д.):

```ruby
require 'yookassa'
require 'json'

class YooKassaWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Если хотите убедиться, что запрос пришел от ЮKassa, добавьте проверку:
    unless YooKassa::SecurityHelper.new.ip_trusted?(request.remote_ip)
      return head :bad_request
    end

    event_json = JSON.parse(request.body.read)

    begin
      # Создание объекта уведомления в зависимости от события
      notification_object = YooKassa::WebhookNotificationFactory.new.create(event_json)
      response_object = notification_object.object

      some_data =
        case notification_object.event
        when YooKassa::WebhookNotificationEventType::PAYMENT_SUCCEEDED,
             YooKassa::WebhookNotificationEventType::PAYMENT_WAITING_FOR_CAPTURE,
             YooKassa::WebhookNotificationEventType::PAYMENT_CANCELED
          { payment_id: response_object.id, payment_status: response_object.status }
        when YooKassa::WebhookNotificationEventType::REFUND_SUCCEEDED
          { refund_id: response_object.id, refund_status: response_object.status, payment_id: response_object.payment_id }
        when YooKassa::WebhookNotificationEventType::DEAL_CLOSED
          { deal_id: response_object.id, deal_status: response_object.status }
        when YooKassa::WebhookNotificationEventType::PAYOUT_SUCCEEDED,
             YooKassa::WebhookNotificationEventType::PAYOUT_CANCELED
          { payout_id: response_object.id, payout_status: response_object.status, deal_id: response_object.deal&.id }
        else
          # Обработка ошибок
          return head :bad_request # Сообщаем кассе об ошибке
        end

      # Специфичная логика
      # ...
      YooKassa::Configuration.configure('XXXXXX', 'test_XXXXXXXX')
      # Получим актуальную информацию о платеже
      if some_data[:payment_id]
        payment_info = YooKassa::Payment.find_one(some_data[:payment_id])
        payment_status = payment_info.status
        # Специфичная логика
        # ...
      end
    rescue StandardError
      # Обработка ошибок
      return head :bad_request # Сообщаем кассе об ошибке
    end

    head :ok # Сообщаем кассе, что все хорошо
  end
end
```
