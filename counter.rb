require 'open-uri'

def just_fetch_page(url)
  return open(url).read
end

def just_count_tags(page, string)
   pattern = /#{string}/
   tags = page.scan(pattern)
   return tags.length
end

sites = [ "http://www.wsj.com", "http://www.nytimes.com", "http://www.washingtonpost.com/" ]
strings = ["Obama","Community","college","Free","Speech"]

sites.each do |url|
   puts "#{url} has:"
   strings.each do |string|
      page = just_fetch_page(url)
      tag_count = just_count_tags(page, string)
      puts "\t - #{tag_count} mentions of #{string}"
   end
end