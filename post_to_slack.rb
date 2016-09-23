require 'sinatra'
require 'json'
require 'open-uri'
require 'uri'
require 'nokogiri'
require 'slack/incoming/webhooks'

 class PostToSlack
    def initialize(item_details)
        @item_details = item_details 
    end
     
    
    def post_to_slack 
        if params[:token] == ENV['TOKEN1']
			slack = Slack::Incoming::Webhooks.new ENV['URL']
			@item_details.map{|arr|
				slack.post "#{arr.strip}"
			}
		elsif params[:token] == ENV['TOKEN2']
			slack = Slack::Incoming::Webhooks.new ENV['URL2']
			@item_details.map{|arr|
				slack.post "#{arr.strip}"
			}
		elsif params[:token] == ENV['TOKEN3']
			slack = Slack::Incoming::Webhooks.new ENV['URL3']
			@item_details.map{|arr|
				slack.post "#{arr.strip}"
			}
	    end
	end
	
 end
