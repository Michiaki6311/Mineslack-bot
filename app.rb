require 'sinatra'
require 'slack/incoming/webhooks'
require './item_search.rb'
require './block_search.rb'
require './recipe_search.rb'
    
    
post '/search' do
    
    if params[:text] =~ /^!mi\s/ then
        mineitem = ItemSearch.new("#{params[:text].gsub(/^!mi\s/,'')}")
        case params[:text].gsub(/^!mi\s/,'')
        # コマンドが"!mi s (検索語)"の場合
        # 完全一致のもののみ
        when /^s\s/ then
            mineitem = ItemSearch.new("#{params[:text].gsub(/^!mi\ss\s/,'')}")
            item_details = mineitem.specific_item_search
        else
            
        # コマンドが"!mi (検索語)"の場合
        # 一部一致するものすべて
            mineitem = ItemSearch.new("#{params[:text].gsub(/^!mi\s/,'')}")
            item_details = mineitem.item_search
        end
        
        
    elsif params[:text] =~ /^!mb\s/ then
        mineblock = BlockSearch.new("#{params[:text].gsub(/^!mb\s/,'')}")
        case params[:text].gsub(/^!mb\s/,'')
        # コマンドが"!mb s (検索語)"の場合
        # 完全一致のもののみ
        when /^s\s/ then
            mineblock = BlockSearch.new("#{params[:text].gsub(/^!mb\ss\s/,'')}")
            item_details = mineblock.specific_block_search
        else
            
        # コマンドが"!mb (検索語)"の場合
        # 一部一致するものすべて
            mineblock = BlockSearch.new("#{params[:text].gsub(/^!mb\s/,'')}")
            item_details = mineblock.block_search
        end
        
        
    elsif params[:text] =~ /^!mr\s/ then
        # コマンドが"!mr (検索語)"の場合
        # 一部一致するものすべて
        minerecipe = RecipeSearch.new("#{params[:text].gsub(/^!mr\s/,'')}")
        item_details = minerecipe.recipe_search
    
    elsif params[:text] =~ /^!mg\s/ then
        # コマンドが"!mg (検索語)"の場合
        # 一部一致するものすべて
        minerecipe = RecipeSearch.new("#{params[:text].gsub(/^!mg\s/,'')}")
        item_details = minerecipe.image_search
    else
        ""
    end
    
    # Slackへの投稿
    
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