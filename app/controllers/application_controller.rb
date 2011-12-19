class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :tracker_restart
  
  def tracker_restart
    
    if Rails.env.production?
      auth = { :username => "", :password => ENV['TWITTER_API_KEY']}
      options = {:query =>{:type => "worker"}, :basic_auth => auth}
      uri = "https://api.heroku.com/apps/proposals-worker/ps/restart"
      return HTTParty.post(uri,options)
    end
    
  end
  
end
