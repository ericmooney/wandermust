class SessionsController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if !params[:destination_id].nil?
        @destination = Destination.find(params[:destination_id]) #if a destination param comes in (i.e. page was rendered from a non-logged-in user that wanted to sign up)
        user.destinations << @destination #push destination into bridge table
      end
      redirect_to destination_path(@destination), :notice => "Nice! You logged in."
    else
      flash.now[:alert] = "Your email or password are not correct."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Okay, you're logged out."
  end
end
