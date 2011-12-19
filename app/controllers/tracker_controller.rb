class TrackerController < ApplicationController
  def restart
    auth = { :username => "", :password => ENV['TWITTER_API_KEY']}
    options = {:query =>{:type => "worker"}, :basic_auth => auth}
    uri = "https://api.heroku.com/apps/proposals-worker/ps/restart"
    render :json => HTTParty.post(uri,options)
  end
end
