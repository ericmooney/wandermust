class DestinationsController < ApplicationController

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
    @destinations = Destination.all
  end

  def show
    @destination = Destination.find(params[:id])
  end
end
