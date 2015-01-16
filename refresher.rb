require 'net/http'

url = "http://nickaversano.github.io/winterterm/"
status = Net::HTTP.get_response(URI::parse(url))  

puts status.status
