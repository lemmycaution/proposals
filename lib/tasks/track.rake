task :track_tweets => :environment do
  require 'rubygems'
  require 'tweetstream'

  @hashtags = Hashtag.select([:id,:tag]).all

  TweetStream.configure do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.oauth_token = ENV['OAUTH_TOKEN']
    config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
    config.auth_method = :oauth
    config.parser   = :yajl
  end    

  client = TweetStream::Client.new    
  # client = TweetStream::Daemon.new('tracker')

  client.on_timeline_status do |status|
    @hashtags.each do |h|
      if status.entities.hashtags.map{|ht| ht['text']}.index(h.tag)
        unless status.text.starts_with? "RT " || status.retweeted
          t = Tweet.find_or_initialize_by_id_str(status.id_str)
          if t.new_record?
            push = true
            t.save
          end
          t.update_attributes({:text => status.text, :username => status.user.name, :retweet_count => status.retweet_count, :tweeted_at => status.created_at})
          t.hashtags << h
          if push
            Pusher['tracker'].trigger_async('new_tweet', {
              :tweet => t
            })
          end
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
    # todo handle missing tweets when disconnected
    puts "tracker: on_reconnect #{timeout} retries #{retries}"
  end

  puts "tracker: start tracking"
  client.track @hashtags.map{ |h| "##{h.tag}"}
end