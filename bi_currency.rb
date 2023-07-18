# Подключаем нужные библиотеки
require 'net/http'
require 'rexml/document'

URL = 'http://www.cbr.ru/scripts/XML_daily.asp'.freeze

# Достаем данные с сайта Центробанка и записываем их в XML
begin
  response = Net::HTTP.get_response(URI.parse(URL))
  doc = REXML::Document.new(response.body)
  # курс доллара
  dollar_exchange_rate = doc.root.elements['//Valute[@ID="R01235"]'].elements['Value'].text.to_i
rescue SocketError => error
  # курс доллара если взять из xml его не вышло
  puts "Enter dollar exchange rate"
  dollar_exchange_rate = $stdin.gets.to_i
end 

# Метод на вход получает кол-во рублей, долларов и обменный курс
def dollars_for_exchange(rubles_in_stock, dollars_in_stock, dollar_exchange_rate)
  # Далее считает кол-во рублей в долларах
  rubles_in_terms_of_dollars = rubles_in_stock / dollar_exchange_rate
  # Потом находим разницу портфелей в долларах и делим на два
  (rubles_in_terms_of_dollars - dollars_in_stock) / 2
end

def display_result(amount)
  if amount.abs < 0.01
    "All OK: #{amount.round(2)}"
    # Если разница положительна значит рублей больше и надо докупить долларов
  elsif amount > 0
    "You should buy $: #{amount.round(2)}"
  else
    # Если разница отрицательна то уже доллары надо продавать - их побольше
    "You should sell $: #{amount.abs.round(2)}"
  end
end

puts "How many rubles do you have?"
rubles_in_stock = gets.to_f
puts "How many dollars do you have?"
dollars_in_stock = gets.to_f

result = dollars_for_exchange(rubles_in_stock, dollars_in_stock, dollar_exchange_rate)
puts display_result(result)
