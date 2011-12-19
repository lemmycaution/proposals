class Hashtag < ActiveRecord::Base
  has_and_belongs_to_many :tweets
  validates :tag, :presence => true
end
