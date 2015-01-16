require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'

base_url = 'https://ntst.umd.edu/soc/'
pages = []
page = Nokogiri::HTML(open(base_url))
page.css('div.course-prefix a').each do |link|
  print '.'
  pages << link
end

puts "there were #{pages.count} pages collected"

courses = []
pages.each do |link|
  page = Nokogiri::HTML(open(base_url + link["href"]))
  department_abbrev = link.css('span.prefix-abbrev').first.content
  department = link.css('span.prefix-name').first.content
  # puts "Department: #{department}"
  dep_courses = page.css('div.course')
  dep_courses.each do |course|
    # print '.'
    courses << course
  end 
  puts "#{department} has #{dep_courses.length} courses"
end

puts "From the #{pages.count} pages, there were #{courses.length} courses collected."