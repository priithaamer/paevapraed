require 'json'
require 'nokogiri'
require 'date'
require 'uri'
require 'net/http'
require 'open-uri'

MonthNames = {
  jaanuar: 1, veebruar: 2, märts: 3, aprill: 4, mai: 5, juuni: 6,
  juuli: 7, august: 8, september: 9, oktoober: 10, november: 11, detsember: 12
}

Prices = {
  'supp' => 2.50,
  'hiina menÜÜ' => 3.50,
  'tai menÜÜ' => 4.50,
  'india menÜÜ' => 4.50
}

def parse_hotpot_date(datestr)
  MonthNames.each do |name, month|
    datestr.gsub!(%r{#{name.to_s}}i, month.to_s)
  end
  
  datestr += ".#{Time.now.strftime('%Y')}"
  datestr.gsub!(/\s+/, '')
  
  DateTime.strptime(datestr, '%d.%m.%Y')
end

doc = Nokogiri::HTML(open('http://hotpot.ee/menuu/paevapakkumine/'))

content = doc.css('#main .width-container')

data = {}
currdate = nil
price = nil
name = nil
description = nil

content.children.each do |item|
  if item.name == 'h2' || item.name == 'h1'
    if name && price && description
      data[currdate][:offers] << {name: name, description: description, price: price}
      name, price, description = nil, nil, nil
    end
    
    currdate = parse_hotpot_date(item.text).strftime('%Y-%m-%d')
    
    data[currdate] = {
      date: currdate,
      city_code: 'tartu',
      country_code: 'ee',
      currency: 'EUR',
      restaurant_code: 'hotpot',
      offers: []
    }
  end
  
  if Prices.keys.include?(item.text.strip.downcase)
    price = Prices.fetch(item.text.strip.downcase)
  end
  
  if item.name == 'p' && item.css('> strong').length > 0
    name = item.children[0].text
    
    if item.children.length > 1
      description = item.children[1].text
    end
  elsif name && description == nil && item.text.length > 1
    description = item.text
  end
  
  if name && price && description
    data[currdate][:offers] << {name: name, description: description, price: price}
    name, price, description = nil, nil, nil
  end
end

puts data.values.to_json
