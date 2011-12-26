class Hashtag < ActiveRecord::Base

  has_and_belongs_to_many :tweets
  validates :tag, :presence => true
  
  before_destroy :destroy_tweets
  
  def proposals 
    self.tweets.order("retweet_count DESC") 
  end
  
   
  
  def destroy_tweets

    ids = []
    self.tweets.each do |t|
      tags = t.hashtags.map{|h| h.tag}
      tags.delete(self.tag)
      ids << t.id if Hashtag.where(:tag => tags ).empty?
      t.destroy
    end
    Tweet.delete(ids)
  end
end
