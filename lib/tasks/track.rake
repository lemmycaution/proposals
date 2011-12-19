task :track_tweets => :environment do
  require 'rubygems'
  require 'tweetstream'

  @hashtags = Hashtag.select([:id,:tag]).all

  TweetStream.configure do |config|
    config.consumer_key = ENV['CONSUMER_KEY_TRACKER']
    config.consumer_secret = ENV['CONSUMER_SECRET_TRACKER']
    config.oauth_token = ENV['OAUTH_TOKEN_TRACKER']
    config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET_TRACKER']
    config.auth_method = :oauth
    config.parser   = :json_gem
  end    

  client = TweetStream::Client.new    
  # client = TweetStream::Daemon.new('tracker')

  client.on_timeline_status do |status|
    @hashtags.each do |h|
      if status.entities.hashtags.map{|ht| ht['text']}.index(h.tag)
        t = Tweet.find_or_create_by_id_str(status.id_str)
        t.update_attributes({:text => status.text, :username => status.user.name, :retweet_count => status.retweet_count}) unless status.text.starts_with? "RT "
        t.hashtags << h
        if t.new_record?
          deferrable = Pusher['tracker'].trigger_async('new_tweet', {
            :tweet => t.to_json
          })
          deferrable.callback {
            # Do something on success
          }
          deferrable.errback { |error|
            # error is a instance of Pusher::Error
          }
        end
      end
    end
  end

  client.on_delete do |status_id, user_id|
    Tweet.delete_by_id_str(status_id.to_s)
  end

  client.on_limit do |skip_count|
    # do something
    puts "tracker: on limit : #{skip_count}"
  end

  client.on_error do |message|
    # send notification email 
    puts "tracker: on error #{message}"
  end

  client.on_reconnect do |timeout, retries|
    puts "tracker: on_reconnect #{timeout} retries #{retries}"
  end

  puts "tracker: start tracking"
  client.track @hashtags.map{ |h| "##{h.tag}"}
end