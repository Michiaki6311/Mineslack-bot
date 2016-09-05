require 'sinatra'
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'slack/incoming/webhooks'
require 'date'

get '/' do
	'Hello,World!'
end

post '/search' do
	if params[:text] =~ /^!mr\s/ then

		array = []
		url = "http://www26.atwiki.jp/minecraft/pages/1073.html"
		items = nil
		timestamp = Time.now.to_i
		searchword = params[:text].gsub(/^!mr\s/,'')

		# parse only first time and keep items
		if !items
			doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
			items = doc.xpath("//tr").select { |tr|
				# FIXME: rowspanned item is not contained
				tr.children.filter('td').length == 3
			}.map { |tr|
				item = tr.children.filter('td')

				{
					name: item[0].text,
					image: item[1].xpath('.//img').map {|img| "http:#{img.attribute('src')}##{timestamp}" }.join("\n"),
					craft: item[2].text,
				}
			}
		end

		items.each do |x|
			if x[:name].downcase! =~ /#{searchword}/
				array.push("#{x[:name]}\n#{x[:craft]}\n#{x[:image]}\n")
			end
		end

		array.push("Not Found") if array == []

		if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
			array.map{|arr|
				slack.post "#{arr.strip}"
			}
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
			array.map{|arr|
				slack.post "#{arr.strip}"
			}
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
			array.map{|arr|
				slack.post "#{arr.strip}"
			}
		end





	elsif params[:text] =~ /^!mg\s/ then
		array = []
		url = "http://www26.atwiki.jp/minecraft/pages/1073.html"
		items = nil
		timestamp = Time.now.to_i
		searchword = params[:text].gsub(/^!mg\s/,'')

		# parse only first time and keep items
		if !items
			doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
			items = doc.xpath("//tr").select { |tr|
				# FIXME: rowspanned item is not contained
				tr.children.filter('td').length == 3
			}.map { |tr|
				item = tr.children.filter('td')

				{
					name: item[0].text,
					image: item[1].xpath('.//img').map {|img| "http:#{img.attribute('src')}##{timestamp}" }.join("\n"),
				}
			}
		end

		items.each do |x|
			if x[:name].downcase! =~ /#{searchword}/
				array.push("#{x[:name]}\n#{x[:image]}\n")
			end
		end

		array.push("Not Found") if array == []

		if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
			array.map{|arr|
				slack.post "#{arr.strip}"
			}
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
			array.map{|arr|
				slack.post "#{arr.strip}"
			}
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
			array.map{|arr|
				slack.post "#{arr.strip}"
			}
		end




	elsif params[:text] =~ /^!mi\s/ then
		url = "http://minecrafter.link/category/%E3%82%A2%E3%82%A4%E3%83%86%E3%83%A0/"
		doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
		searchword = params[:text].gsub(/^!mi\s/,'')
		details = nil
		items = nil
		ary = []
		item_details = []
		timestamp = Time.now.to_i

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
						image: detail.xpath('//div[@class="item_img"]/img').attribute('src').value + "##{timestamp}",
						text: detail.xpath('//div[@class="text bg_box"]').text,
					}
				}
			end

			details.each do |detail|
				item_details.push("#{detail[:name]}\n#{detail[:image]}\n#{detail[:text]}\n")
			end


			if params[:token] == ENV['TOKEN1']
				slack = Slack::Incoming::Webhooks.new ENV['URL']
				item_details.map{|arr|
					slack.post "#{arr.strip}"
				}
			elsif params[:token] == ENV['TOKEN2']
				slack = Slack::Incoming::Webhooks.new ENV['URL2']
				item_details.map{|arr|
					slack.post "#{arr.strip}"
				}
			elsif params[:token] == ENV['TOKEN3']
				slack = Slack::Incoming::Webhooks.new ENV['URL3']
				item_details.map{|arr|
					slack.post "#{arr.strip}"
				}
			end

		end


	else ""

	end

end
