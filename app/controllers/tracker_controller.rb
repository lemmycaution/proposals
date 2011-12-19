class TrackerController < ApplicationController
  
  respond_to :json
  
  def restart
    
    if Rails.env.production?
      auth = { :username => "", :password => ENV['TWITTER_API_KEY']}
      options = {:query =>{:type => "worker"}, :basic_auth => auth}
      uri = "https://api.heroku.com/apps/proposals-worker/ps/restart"
      response = HTTParty.post(uri,options)
    else
      # Thread.new { system('bundle exec rvmsudo restart proposal-worker-1') }
      respond = {"OK"} 
    end
    
    respond_with respond
    
  end
end
