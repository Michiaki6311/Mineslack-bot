require 'sinatra'
require './item_search.rb'
require './block_search.rb'
require './recipe_search.rb'
require './post_to_slack.rb'
    
    
post '/search' do
    if params[:text] =~ /^!mi\s/ then
        mineitem = ItemSearch.new("#{params[:text].gsub(/^!mi\s/,'')}")
        case params[:text].gsub(/^!mi\s/,'')
        # コマンドが"!mi s (検索語)"の場合
        # 完全一致のもののみ
        when /^s\s/ then
            mineitem = ItemSearch.new("#{params[:text].gsub(/^!mi\ss\s/,'')}")
            result = mineitem.specific_item_search
        else
            
        # コマンドが"!mi (検索語)"の場合
        # 一部一致するものすべて
            mineitem = ItemSearch.new("#{params[:text].gsub(/^!mi\s/,'')}")
            result = mineitem.item_search
        end
        
        
    elsif params[:text] =~ /^!mb\s/ then
        mineblock = BlockSearch.new("#{params[:text].gsub(/^!mb\s/,'')}")
        case params[:text].gsub(/^!mb\s/,'')
        # コマンドが"!mb s (検索語)"の場合
        # 完全一致のもののみ
        when /^s\s/ then
            mineblock = BlockSearch.new("#{params[:text].gsub(/^!mb\ss\s/,'')}")
            result = mineblock.specific_block_search
        else
            
        # コマンドが"!mi (検索語)"の場合
        # 一部一致するものすべて
            mineblock = BlockSearch.new("#{params[:text].gsub(/^!mb\s/,'')}")
            result = mineblock.block_search
        end
        
        
    elsif params[:text] =~ /^!mr\s/ then
        # コマンドが"!mr (検索語)"の場合
        # 一部一致するものすべて
        minerecipe = RecipeSearch.new("#{params[:text].gsub(/^!mr\s/,'')}")
        result = minerecipe.recipe_search
    
    elsif params[:text] =~ /^!mg\s/ then
        # コマンドが"!mg (検索語)"の場合
        # 一部一致するものすべて
        minerecipe = RecipeSearch.new("#{params[:text].gsub(/^!mg\s/,'')}")
        result = minerecipe.image_search
    else
        ""
    end
    
    # Slackへの投稿
    minepost = PostToSlack.new(result)
    minepost.post_to_slack
end