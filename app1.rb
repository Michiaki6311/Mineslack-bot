require 'sinatra'
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'

response = ""

get '/' do
	'Hello,World!'
end

post '/search' do
	if params[:text] =~ /^!mi\s/ then
		url = "http://minecrafter.link/category/%E3%82%A2%E3%82%A4%E3%83%86%E3%83%A0/"
		doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
		searchword = params[:text].gsub(/^!mi\s/,'')
		details = nil
		items = nil
		ary = []
		item_details = []
		array = []

		if !items
			items = doc.xpath("//article/header/h2").map{|node|
				{
					name: node.text,
					url: node.xpath('a').attribute('href').value,
				}
			}
		else
			""
		end

		items.each do |item|
			if item[:name] =~ /#{searchword}/ then
				ary.push("#{item[:url]}")
			end
		end
		
		
		
		if ary == [] then
			item_details.push('Not Found')
		else

		ary.each do |item_url|
			doc = Nokogiri::HTML.parse(open(item_url), nil, "utf-8")
			details = doc.xpath("//article").map{|detail|
				{
					name: detail.xpath('//h2[@class="entry-title post_title"]').text,
					image: detail.xpath('//div[@class="item_img"]/img').attribute('src').value,
					text: detail.xpath('//div[@class="text bg_box"]').text,
				}
			}
			details.each do |detail|
				item_details.push("#{detail[:name]}\n#{detail[:image]}\n#{detail[:text]}\n")
		    end
		end
			
		item_details
		
	    end
		
	end
end
