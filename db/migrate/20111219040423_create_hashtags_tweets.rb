class CreateHashtagsTweets < ActiveRecord::Migration
  def up
    create_table :hashtags_tweets, :id => false do |t|
      t.references :hashtag, :tweet
    end
    add_index :hashtags_tweets, :hashtag_id
    add_index :hashtags_tweets, :tweet_id
  end

  def down
    drop_table :hashtags_tweets
  end
end
