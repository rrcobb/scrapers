# this scraper finds all the submissions after a certain date and outputs the html for the SOaGS post 
# need to keep track of the most recent SOaGS post date
# look at the nokogiri docs to understand how we are parsing the page
require 'nokogiri'
require 'open-uri'
require 'date'

n = 20 #number of pages to capture - if there are more posts between dates, change this!
Last_date_string = "Nov 3, 2014 10:06 pm"  #here's where you put the last time you checked!
Last_date = DateTime.strptime(Last_date_string, "%b %d, %Y %I:%M %p") 
base_url = 'http://edrecoveryprobs.com/tagged/submission/page/'
page_one = 'http://edrecoveryprobs.com/tagged/submission' # page one is different, add it first

urls = []
urls << page_one # add the first page

# build the urls for the other pages
for i in 2..n
  urls << base_url + i.to_s
end

#hash to keep track of the names of those who are being recognized and how many times they each submitted
submitters = {}

# go to each page
urls.each do |url|
  page = Nokogiri::HTML(open(url))
  #use nokogiri css to find the posts
  posts = page.css('div.post')
  #go through each post on the page
  posts.each do |post|
    #find the link that will have the name we want
    link = post.css('div.lP div.body p a')
    #find the date of each post
    date_node = post.css('div.meta ul.facts li.date a')
    if !date_node[0].nil?
      #convert the date into a ruby date to compare to the last time we posted
      date = DateTime.strptime(date_node[0].text, "%b %d, %Y %I:%M %p")
      #if we are older than the last update, get out!
      if date < Last_date
        break
      end
    end
    #add the names to the submitters hash and add to the count
    if !link[0].nil?
      name = link[0].text.gsub(/\(|\)/,'')
      submitters[name] ||= 0
      submitters[name] += 1
    end
  end
end

#print out the names in the right format for the post
puts "<ul>"
submitters.sort_by{|name, number| -number}.each do |k,v|
  puts "<li><span><a href=\"http://#{k}.tumblr.com/ask\">#{k}</a> (#{v})</span></li>"
end
puts "</ul>"