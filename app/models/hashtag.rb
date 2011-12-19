class Hashtag < ActiveRecord::Base

  has_and_belongs_to_many :tweets
  validates :tag, :presence => true
  
  before_destroy :destroy_tweets
  
  private 
  
  def destroy_tweets
    self.tweets.each do |t|
      t.destroy if t.hashtags.count == 1
    end
  end
end
