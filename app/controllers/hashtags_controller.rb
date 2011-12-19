class HashtagsController < ApplicationController
  
  respond_to :html, :json, :xml
  
  def index
    @hashtags = Hashtag.order("created_at DESC").all
    respond_with @hashtags    
  end
  
  def show
    @hashtag = Hashtag.find(params[:id])
    respond_with @hashtag
  end
  
  def new
    @hashtag = Hashtag.new
    respond_with @hashtag
  end
  
  def create
    @hashtag = Hashtag.create(params[:hashtag])
    puts tracker_restart
    respond_with @hashtag, :location => hashtag_url(@hashtag)
  end
  
  def destroy
    @hashtag = Hashtag.find(params[:id]).destroy
    puts tracker_restart
    respond_with @hashtag, :location => hashtags_url
  end  

end
