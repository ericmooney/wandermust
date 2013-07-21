class SessionsController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def new
    @user = User.new
  end

  def create
    begin
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        if !params[:destination_id].nil?
          @destination = Destination.find(params[:destination_id]) #if a destination param comes in (i.e. page was rendered from a non-logged-in user that wanted to sign up)
          if !user.destinations.include?(@destination)
            user.destinations << @destination #push destination into bridge table
          else
            flash[:alert] = "That favorite is already in your list."
          end
        end
        redirect_to user_path(user), :notice => "Nice! You logged in."
      else
        flash.now[:alert] = "Your email or password are not correct."
        render :new
      end
    rescue
      @user = User.new
      flash.now[:alert] = "Your email or password are not correct."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "All logged out, come back soon!."
  end
end
