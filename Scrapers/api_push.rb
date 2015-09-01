require 'uri'
require 'net/http'

uri = URI('http://voog.construction:3000/api/v1/offers')
req = Net::HTTP::Post.new(uri)
req.body = $stdin.read

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end
