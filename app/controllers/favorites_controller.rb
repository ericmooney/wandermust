class FavoritesController < ApplicationController

  skip_before_filter :require_admin_authentication, :only => [:destroy]

  def destroy
    @user = User.find(session[:user_id])
    @favorite = Favorite.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end