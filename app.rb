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

		url = "http://minecraft-ja.gamepedia.com/%E3%82%AB%E3%83%86%E3%82%B4%E3%83%AA:%E3%82%A2%E3%82%A4%E3%83%86%E3%83%A0"
		doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
		items = nil
		array = []
		searchword = params[:text].gsub(/^!mi\s/,'')
		item_details = []
		details = []
		new_url = []
		timestamp = Time.now.to_i

		if !items
			items = doc.xpath("//div[@id='mw-pages']//div[@class='mw-category-group']/ul/li").map{|node|
				{
					name: node.text.downcase,
					url: "http://minecraft-ja.gamepedia.com/"+ node.text,

				}
			}

			items.each do |item|
				if item[:name] =~ /#{searchword}/ then 
					array.push("#{item[:url]}")
				end
			end

			array.each do |item_url|
				new_url.push(URI.encode(item_url))
			end

			new_url.each do |new_item_url|
				doc = Nokogiri::HTML.parse(open(new_item_url), nil, "utf-8") 
				details = doc.xpath("//div[@class='mw-body']").map{|node|
					{
						name: node.xpath("//h1").text,
						image: node.xpath("//div[@class='infobox-imagearea']//img").attribute('src').value + "##{timestamp}",
						description: node.xpath("//div[@class='mw-content-ltr']/p|//div[@class='mw-content-ltr']/ul/li[not(@class) and not(*)]").text,

					}
				}

				details.each do |detail|
					item_details.push("#{detail[:name]}\n#{detail[:image]}\n#{detail[:description]}\n")
				end
			end
		end

		if item_details == [] then
			item_details.push('Not Found')
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
		
		
		elsif params[:text] =~ /^!mb\s/ then

		url = "http://minecraft-ja.gamepedia.com/%E3%82%AB%E3%83%86%E3%82%B4%E3%83%AA:%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF"
		doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
		items = nil
		array = []
		searchword = params[:text].gsub(/^!mb\s/,'')
		item_details = []
		details = []
		new_url = []
		timestamp = Time.now.to_i

		if !items
			items = doc.xpath("//div[@id='mw-pages']//div[@class='mw-category-group']/ul/li").map{|node|
				{
					name: node.text.downcase,
					url: "http://minecraft-ja.gamepedia.com/"+ node.text,

				}
			}

			items.each do |item|
				if item[:name] =~ /#{searchword}/ then 
					array.push("#{item[:url]}")
				end
			end

			array.each do |item_url|
				new_url.push(URI.encode(item_url))
			end

			new_url.each do |new_item_url|
				doc = Nokogiri::HTML.parse(open(new_item_url), nil, "utf-8") 
				details = doc.xpath("//div[@class='mw-body']").map{|node|
					{
						name: node.xpath("//h1").text,
						image: node.xpath("//div[@class='infobox-imagearea']//img").attribute('src').value + "##{timestamp}",
						description: node.xpath("//div[@class='mw-content-ltr']/p|//div[@class='mw-content-ltr']/ul/li[not(@class) and not(*)]").text,

					}
				}

				details.each do |detail|
					item_details.push("#{detail[:name]}\n#{detail[:image]}\n#{detail[:description]}\n")
				end
			end
		end

		if item_details == [] then
			item_details.push('Not Found')
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
			


	else
		""

	end
	
	

end
