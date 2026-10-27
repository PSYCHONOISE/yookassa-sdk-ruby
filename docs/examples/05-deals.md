## Работа со сделками

SDK позволяет создавать сделки, а также получать информацию о них.

Объект сделки `YooKassa::DealResponse` содержит всю информацию о сделке, актуальную на текущий момент времени.
Он формируется при создании сделки и приходит в ответ на любой запрос, связанный со сделками.

* [Запрос на создание сделки](#Запрос-на-создание-сделки)
* [Запрос на создание сделки через билдер](#Запрос-на-создание-сделки-через-билдер)
* [Получить информацию о сделке](#Получить-информацию-о-сделке)
* [Получить список сделок с фильтрацией](#Получить-список-сделок-с-фильтрацией)

---

### Запрос на создание сделки

[Создание сделки в документации](https://yookassa.ru/developers/api#create_deal)

Чтобы создать сделку, необходимо создать объект сделки — `YooKassa::DealRequest`. Он позволяет создать сделку,
в рамках которой необходимо принять оплату от покупателя и перечислить ее продавцу.

В ответ на запрос придет объект сделки - `YooKassa::DealResponse` в актуальном статусе.

```ruby
require 'yookassa'
require 'pp'

res = YooKassa::Deal.create({
  'type' => 'safe_deal',
  'fee_moment' => 'payment_succeeded',
  'metadata' => {
    'order_id' => '88'
  },
  'description' => 'SAFE_DEAL RUBY 123554642-2432FF344R'
})

pp res.to_h
```
---

### Запрос на создание сделки через билдер

[Создание сделки в документации](https://yookassa.ru/developers/api#create_deal)

Билдер позволяет создать объект сделки — `YooKassa::DealRequest` программным способом, через объекты.

```ruby
require 'yookassa'
require 'pp'

builder = YooKassa::DealRequestBuilder.new
builder.set_type(YooKassa::DealType::SAFE_DEAL)
       .set_fee_moment(YooKassa::FeeMoment::PAYMENT_SUCCEEDED)
       .set_description('SAFE_DEAL 123554642-2432FF344R')
       .set_metadata({ 'order_id' => '37' })

request = builder.build
# Можно что-то поменять, если нужно
request.description = 'SAFE_DEAL RUBY 123554642-2432FF344R'
res = YooKassa::Deal.create(request)

pp res.to_h
```
---

### Получить информацию о сделке

[Информация о сделке в документации](https://yookassa.ru/developers/api)

Запрос позволяет получить информацию о текущем состоянии сделки по его уникальному идентификатору.

В ответ на запрос придет объект сделки - `YooKassa::DealResponse` в актуальном статусе.

```ruby
require 'yookassa'
require 'pp'

res = YooKassa::Deal.find_one('dl-285e5ee7-0022-5000-8000-01516a44b147')

pp res.to_h
```
---

### Получить список сделок с фильтрацией

[Список сделок в документации](https://yookassa.ru/developers/api#get_deals_list)

Запрос позволяет получить список сделок, отфильтрованный по заданным критериям.

В ответ на запрос вернется список сделок с учетом переданных параметров. В списке будет информация о сделках,
созданных за последние 3 года. Список будет отсортирован по времени создания сделок в порядке убывания.

Если результатов больше, чем задано в `limit`, список будет выводиться фрагментами. В этом случае в ответе на
запрос вернется фрагмент списка и параметр `next_cursor` с указателем на следующий фрагмент.

```ruby
require 'yookassa'
require 'pp'

cursor = nil
data = {
  'limit' => 10,                                     # Ограничиваем размер выборки
  'status' => 'closed',                               # Выбираем только закрытые сделки
  'full_text_search' => 'RUBY',                       # Фильтр по описанию сделки — параметру description
  'created_at.gte' => '2021-08-01T00:00:00.000Z',     # Созданы начиная с 2021-08-01
  'created_at.lt' => '2021-11-20T00:00:00.000Z'       # И до 2021-11-20
}

loop do
  params = data
  params['cursor'] = cursor if cursor

  begin
    res = YooKassa::Deal.list(params)
    puts " items: #{res.items.size}"      # Количество сделок в выборке
    puts "cursor: #{res.next_cursor}"     # Указатель на следующую страницу
    pp res.to_h

    break unless res.next_cursor

    cursor = res.next_cursor
  rescue YooKassa::ApiError => e
    puts " Error: #{e.message}"
    break
  end
end
```
[Подробнее о работе со списками](https://yookassa.ru/developers/using-api/lists)
