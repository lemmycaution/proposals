require 'rubygems'
require 'clockwork'
require 'json'
require 'twitter'

ENV['RAILS_ENV'] = ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

include Clockwork
include Twitter
include JSON

# Configure Twitter Credentials
Twitter.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY_UPDATER']
  config.consumer_secret = ENV['CONSUMER_SECRET_UPDATER']
  config.oauth_token = ENV['OAUTH_TOKEN_UPDATER']
  config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET_UPDATER']
end

# Initialize your Twitter client
client = Twitter::Client.new

handler do |job|
  Tweet.all.each do |t|
    begin
      rc = Twitter.status(t.id_str).retweet_count
      if rc != t.retweet_count
        t.update_attribute(:retweet_count, rc) 
        Pusher['updater'].trigger('update_tweet', {
          :tweet => t
        })
      end
    rescue Twitter::NotFound        
      t.destroy
    rescue Twitter::BadRequest
      # rate limit :(  
      # puts "updater: rate limit exceeded"
    end
    
  end
end

# do it every minute
every(10.minute, 'update_retweet_counts')