class HashtagsController < ApplicationController
  
  respond_to :html, :json, :xml
  
  def index
    @hashtags = Hashtag.order("created_at DESC").page params[:page]
    respond_with @hashtags    
  end
  
  def show
    @hashtag = Hashtag.find(params[:id])
    @proposals = @hashtag.proposals.page params[:page]
    respond_with @hashtag
  end
  
  def new
    @hashtag = Hashtag.new
    respond_with @hashtag
  end
  
  def create
    @hashtag = Hashtag.new(params[:hashtag])
    @is_tracker_restarted = tracker_restart
    if @hashtag.save
      respond_with @hashtag, :location => hashtag_url(@hashtag)
    else
      respond_with @hashtag, :location => new_hashtag_url(@hashtag)
    end  
  end
  
  def destroy
    @hashtag = Hashtag.find(params[:id]).destroy
    @is_tracker_restarted = tracker_restart
    respond_with @hashtag, :location => hashtags_url
  end  

end
