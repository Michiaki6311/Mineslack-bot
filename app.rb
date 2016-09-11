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
						description: node.xpath("//div[@class='mw-content-ltr']/h3|//div[@class='mw-content-ltr']/h2|//div[@class='mw-content-ltr']/p|//div[@class='mw-content-ltr']/ul/li[not(@class) and not(*)]").map{|new_node|
						if new_node.to_html =~ /<h2/ then
							case new_node.text
							when /歴史|ギャラリー|脚注/
							then
							""
						    else
							new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|
							
								"*"+new_new_node+"*"
							}.join("\n")
						    end
						elsif new_node.to_html =~ /<h3/ then
						    new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|
						    
						    	"_"+new_new_node+"_"
						    }.join("\n")
						elsif new_node.to_html =~ /<li>/ then
						    "・"+new_node.text
						elsif new_node.to_html =~ /<p>/ then
						    new_node.text
						end
						}

					}
				}

				details.each do |detail|
					item_details.push("#{detail[:name]}\n#{detail[:image]}\n#{detail[:description].join("\n")}\n\n")
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
						name: "*"+node.xpath("//h1").text+"*",
						image: node.xpath("//div[@class='infobox-imagearea']//img").attribute('src').value + "##{timestamp}",
						description: node.xpath("//div[@class='mw-content-ltr']/h3|//div[@class='mw-content-ltr']/h2|//div[@class='mw-content-ltr']/p|//div[@class='mw-content-ltr']/ul/li[not(@class) and not(*)]").map{|new_node|
						if new_node.to_html =~ /<h2/ then
							case new_node.text
							when /歴史|ギャラリー|脚注|関連|参照|参考/
							then
							""
						    else
							new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|
							
								"*"+new_new_node+"*"
							}.join("\n")
						    end
						elsif new_node.to_html =~ /<h3/ then
						    new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|
						    
						    	"_"+new_new_node+"_"
						    }.join("\n")
						elsif new_node.to_html =~ /<li>/ then
						    "・"+new_node.text
						elsif new_node.to_html =~ /<p>/ then
						    new_node.text
						end
						}

					}
				}

				details.each do |detail|
					item_details.push("#{detail[:name]}\n#{detail[:image]}\n#{detail[:description].join("\n")}\n\n")
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
			
			
	elsif params[:text] =~ /^!m\sbrew/ then
	    url = "https://hydra-media.cursecdn.com/minecraft-ja.gamepedia.com/0/0d/MinecraftPotionsSimple.png"
	    timestamp = Time.now.to_i
	    
		if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
				slack.post "#{url}" + "##{timestamp}"
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
				slack.post "#{url}" + "##{timestamp}"
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
				slack.post "#{url}" + "##{timestamp}"
		end	
		
		
	elsif params[:text] =~ /^!m\sblocks/ then
	    url = "https://hydra-media.cursecdn.com/minecraft-ja.gamepedia.com/3/32/Template1.png"
	    timestamp = Time.now.to_i
	    
		if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
				slack.post "#{url}" + "##{timestamp}"
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
				slack.post "#{url}" + "##{timestamp}"
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
				slack.post "#{url}" + "##{timestamp}"
		end	
		
		
	elsif params[:text] =~ /^!m\sore/ then
	    url = "https://gyazo.com/9b07420102f70bdbbe69d24acc26494a"
	    timestamp = Time.now.to_i
	    
		if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
				slack.post "#{url}"
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
				slack.post "#{url}"
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
				slack.post "#{url}"
		end	
		
		
	elsif params[:text] =~ /^!m\senchant/ then
	    url = "https://gyazo.com/c9db51aaca5b53a575c86dd80a0924c0"
	    timestamp = Time.now.to_i
	    
		if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
				slack.post "#{url}"
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
				slack.post "#{url}"
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
				slack.post "#{url}"
		end	


	else
		""

	end
	
	

end
