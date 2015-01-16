#ruby script to create posts from urls

require 'open-uri'
require 'nokogiri'
require 'date'

print "url: "
url = gets.strip
print "title: "
title = gets.strip

page = Nokogiri::HTML(open(url))
date = page.css("time.entry-date").text
article = page.css("div.entry-content p")
images = page.css("div.entry-content img")
imageurls = images.map {|image| image["src"]}
imagealts = images.map {|image| image["alt"]}
parsed = article.to_s.gsub(/<\/?[^>]+>/, '').gsub(/\s{3,}/,'').gsub(/\&acirc;&#128;/, '').gsub(/\&#148;/, "--").gsub(/\&#153;/,"'").gsub(/\&#156;|\&#157;/, "\"").gsub(/\.(?<foo>\w)/,". \n\n\\k<foo>").gsub(/\n/,"\n\n")
string = "---
layout: post
title: #{title}
description: 
categories: blog
date: #{date}
tags: [blog]
keywords: 
image: 
---
*This post originally appeared on the blog [Learning Learning](#{url})*

#{parsed}
"
string = string + "#{imagealts.each{ |alt| alt } }
#{imageurls.each{ |url| url } }".gsub(/,/,"\n").gsub(/\[|\]|\"/,'')


filename = "/Users/robertcobb/Desktop/dev/rob/_posts/#{Date.parse(date).strftime('%Y-%m-%d')}-#{title.downcase.gsub(/[^0-9a-z ]/i, '').gsub(/ /,'-')}.md"
f = File.new(filename, "w")
f.write(string)
f.close