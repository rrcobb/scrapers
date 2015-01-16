require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

base_url = 'https://ntst.umd.edu/soc/'
pages = []
page = Nokogiri::HTML(open(base_url))
page.css('div.course-prefix a').each do |link|
  puts base_url + link["href"]
  pages << link["href"]
end

puts "there were #{pages.count} pages collected"