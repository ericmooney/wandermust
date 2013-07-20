class UsersController < ApplicationController

  skip_before_filter :require_authentication, :only => [:new, :create]
  skip_before_filter :require_admin_authentication, :only => [:new, :create, :edit, :update, :show]

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def show
    @user = User.find(session[:user_id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        if !params[:destination_id].nil?
          @destination = Destination.find(params[:destination_id]) #if a destination param comes in (i.e. page was rendered from a non-logged-in user that wanted to sign up)
          @user.destinations << @destination #push destination into bridge table
        end
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { redirect_to root_path, alert: 'There was an error with signing up, please try again.' }
        format.js
      end
    end
  end

  def update
    @user = User.find(session[:user_id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end
end
