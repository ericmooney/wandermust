class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_authentication
  before_filter :require_admin_authentication
  before_filter :set_new_user_variable

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
  helper_method :current_user

  def require_authentication
    if current_user.nil?
      redirect_to  root_path, :alert => "You must be logged in."
    end
  end

  def require_admin_authentication
    if !current_user.nil? && !current_user.is_admin?
      redirect_to root_path, :alert => "You must be logged in as an admin."
    end
  end

  # Since the modal for logging in will be on every page, the @user has to be set for the page to render
  # If @user needs to be something different, it will be set in the specific controller
  def set_new_user_variable
    if current_user.nil?
      @user = User.new
    end
  end

end
