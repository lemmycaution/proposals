class TrackerController < ApplicationController
  
  respond_to :json
  
  def restart

    respond_with tracker_restart
    
  end
  
end
