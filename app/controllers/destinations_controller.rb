class DestinationsController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
    @destinations = Destination.all
  end

  def create
    @destination = Destination.new

    respond_to do |format|
      if @destination.save
        format.html { redirect_to @destination }
        format.js
      else
        format.html { render action: "index" }
        format.js
      end
    end
  end

  def show
    @destination = Destination.find(params[:id])
  end

  def save
    @destination = Destination.find(params[:id])

    if !session[:user_id].blank?  #if the session has started i.e. the customer is logged in
      @user = User.find(session[:user_id])  #grab the user object
      @user.destinations << @destination  #update the bridge table to associate the user and destination
      redirect_to user_path(@user)
    else
      @user = User.new
      @destination = Destination.find(params[:id]) #if not logged in, grab the destination object to be used after the login..
      render new_session_path
    end
  end

end
