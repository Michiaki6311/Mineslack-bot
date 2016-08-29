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
        
        response = array
        response = "Not Found" if array == []
        
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
        
        response = array
        response = "Not Found" if array == []
        
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
      
    else ""
      
    end
    
end