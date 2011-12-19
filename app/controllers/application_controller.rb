class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :tracker_restart
  
  def tracker_restart
    
    if Rails.env.production?
      
      # auth = { :username => "", :password => ENV['HEROKU_API_KEY']}
      # options = {:query =>{:type => "worker"}, :basic_auth => auth}
      # uri = "https://api.heroku.com/apps/proposals-worker/ps/restart"
      # return HTTParty.post(uri,options)
      @hc = Heroku::Client.new(ENV['HEROKU_API_USER'],ENV['HEROKU_API_KEY'])
      @hc.ps_restart("proposals-worker",{:type => "worker"})
    end

  end
  
end
