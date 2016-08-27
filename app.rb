require 'sinatra'
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'slack/incoming/webhooks'

get '/' do
  'Hello,World!'
end

post '/search' do
    if params[:text] =~ /^!mr\s/ then
      
      array = []
      url = "http://www26.atwiki.jp/minecraft/pages/1073.html"
      items = nil
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
            image: item[1].xpath('.//img').map {|img| "http:#{img.attribute('src')}#.png" }.join("\n"),
            craft: item[2].text,
          }
        }
      end

      items.each do |x|
        if x[:name] =~ /#{searchword}/
          array.push("#{x[:name].downcase!}\n#{x[:craft]}\n#{x[:image]}\n")
        end
      end
        
        response = array.join.strip
        response = array.sample if response.strip.length > 1024
        response = "Not Found" if array == []
        
        slack = Slack::Incoming::Webhooks.new ENV['URL']
        slack.post "#{response.strip}"
        
        elsif params[:text] =~ /^!mg\s/ then
        response = "hi"
    end
    
end