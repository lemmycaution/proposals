class Tweet < ActiveRecord::Base
  has_and_belongs_to_many :hashtags
  validates :id_str, :presence => true, :uniqueness => true
  validates :text, :username, :presence => true  
end
