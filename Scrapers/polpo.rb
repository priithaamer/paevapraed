require 'json'
require 'nokogiri'
require 'date'
require 'open-uri'

doc = Nokogiri::HTML(open('http://polpo.ee/paevapakkumine/'))

content = doc.css('.l-main .wpb_wrapper')

data = {
  date: Date.today.strftime('%Y-%m-%d'),
  city_code: 'tartu',
  country_code: 'ee',
  currency: 'EUR',
  restaurant_code: 'polpo',
  offers: []
}

content.css('p').each do |p|
  if p.text =~ /(.*)(\d+\.\d+)€/
    data[:offers] << {name: Regexp.last_match[1].strip, price: Regexp.last_match[2].to_f}
  end
end

puts data.to_json
