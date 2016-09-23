require 'sinatra'
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'    

class BlockSearch
	def initialize(searchword)
		@searchword = searchword
	end

	# ブロック検索(曖昧検索)
	def block_search
		array = []
		items = nil
		url = "http://minecraft-ja.gamepedia.com/%E3%82%AB%E3%83%86%E3%82%B4%E3%83%AA:%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF"
		new_url = []
		doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
		item_details = []
		details = []
		timestamp = Time.now.to_i

		if !items
			items = doc.xpath("//div[@id='mw-pages']//div[@class='mw-category-group']/ul/li").map{|node|
				{
					name: node.text.downcase,
					url: "http://minecraft-ja.gamepedia.com/"+ node.text,

				}
			}
		end

		items.each do |item|
			if item[:name] =~ /#{@searchword}/ then 
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
					url: "<"+new_item_url+"|Wikiへのリンク>",
					name: "*・" + node.xpath("//h1").text + "*",
					image: if node.xpath("//div[@class='infobox-imagearea']//img").empty? then
						       ""
				else
					node.xpath("//div[@class='infobox-imagearea']//img").attribute('src').value + "##{timestamp}"
				end,
				description: node.xpath("//div[@class='mw-content-ltr']/h3|//div[@class='mw-content-ltr']/h2|//div[@class='mw-content-ltr']//table[@class='wikitable']|//div[@class='mw-content-ltr']/p|//div[@class='mw-content-ltr']/ul/li[not(@class)]").map{|new_node|

					if new_node.to_html =~ /<h2/ then
						new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|

							"*"+new_new_node+"*"
						}.join("\n")

					elsif new_node.to_html =~ /<h3/ then
						new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|

							"_"+new_new_node+"_"
						}.join("\n")
					elsif new_node.to_html =~ /<table/ then
						"<テーブルあり。リンク先を参照>"
					elsif new_node.to_html =~ /<li>/ then
						"・"+new_node.text
					elsif new_node.to_html =~ /<p>/ then
						new_node.text
					end
				}

				}
			}


			details.each do |detail|
				item_details.push("#{detail[:name]}\n#{detail[:url]}\n#{detail[:image]}\n#{detail[:description].join("\n")}\n\n")
			end

		end

		if item_details == [] then
			item_details.push('Not Found')
		end

		item_details.each do |detail|
			detail.strip
		end

	end

	# ブロック検索(厳密検索)
	def specific_block_search
		array = []
		items = nil
		url = "http://minecraft-ja.gamepedia.com/%E3%82%AB%E3%83%86%E3%82%B4%E3%83%AA:%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF"
		new_url = []
		doc = Nokogiri::HTML.parse(open(url), nil, "utf-8")
		item_details = []
		details = []
		timestamp = Time.now.to_i

		if !items
			items = doc.xpath("//div[@id='mw-pages']//div[@class='mw-category-group']/ul/li").map{|node|
				{
					name: node.text.downcase,
					url: "http://minecraft-ja.gamepedia.com/"+ node.text,

				}
			}
		end

		items.each do |item|
			if item[:name] == "#{@searchword}" then 
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
					url: "<"+new_item_url+"|Wikiへのリンク>",
					name: "*・" + node.xpath("//h1").text + "*",
					image: if node.xpath("//div[@class='infobox-imagearea']//img").empty? then
						       ""
				else
					node.xpath("//div[@class='infobox-imagearea']//img").attribute('src').value + "##{timestamp}"
				end,
				description: node.xpath("//div[@class='mw-content-ltr']/h3|//div[@class='mw-content-ltr']/h2|//div[@class='mw-content-ltr']//table[@class='wikitable']|//div[@class='mw-content-ltr']/p|//div[@class='mw-content-ltr']/ul/li[not(@class)]").map{|new_node|

					if new_node.to_html =~ /<h2/ then
						new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|

							"*"+new_new_node+"*"
						}.join("\n")

					elsif new_node.to_html =~ /<h3/ then
						new_node.children.filter("//span[@class='mw-headline']").map{|new_new_node|

							"_"+new_new_node+"_"
						}.join("\n")
					elsif new_node.to_html =~ /<table/ then
						"<テーブルあり。リンク先を参照>"
					elsif new_node.to_html =~ /<li>/ then
						"・"+new_node.text
					elsif new_node.to_html =~ /<p>/ then
						new_node.text
					end
				}

				}
			}


			details.each do |detail|
				item_details.push("#{detail[:name]}\n#{detail[:url]}\n#{detail[:image]}\n#{detail[:description].join("\n")}\n\n")
			end

		end

		if item_details == [] then
			item_details.push('Not Found')
		end

		item_details.each do |detail|
			detail.strip
		end

	end

end
