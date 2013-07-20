class DestinationsController < ApplicationController
  require "open-uri"
  require 'wikipedia'

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
  end

  def complete
    @destinations = Destination.all
    @destination = Destination.find(4)
  end

  def create
    # Use Geocoder to pull back a city, if no city returns, create new random coordinates
    @destination = Destination.new
    @destination.get_random_coordinates

    # make sure the destination has a valid city returned, delete errors SEE IF I CAN do this before saving a record to DB
    if [0,1,2].include?(@destination.address)
      until ![0,1,2].include?(@destination.address)
        @destination.destroy
        @destination = Destination.new
        @destination.get_random_coordinates
      end
    end


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

    begin
      response = RubyWebSearch::Google.search(:query => "#{@destination.address} site:en.wikipedia.org").results.first[:url]
      wiki_content = Nokogiri::HTML(open(response))
      summary = wiki_content.css("#mw-content-text p")[0].content
      if (summary.blank? || summary.include?("Coordinates"))
        summary = wiki_content.css("#mw-content-text p")[1].content
        if (summary.include?("may refer to") || summary.blank?)
          raise
        else
          @summary = summary
        end
      else
        @summary = summary
      end
    rescue
      response = RubyWebSearch::Google.search(:query => "#{@destination.address.split(", ")[0]}, #{@destination.address.split(", ")[2]} site:en.wikipedia.org").results.first[:url]
      wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[1].titleize.gsub(" ", "_")}"))
      @summary = wiki_content.css("#mw-content-text p")[0].content
    end

    page = Wikipedia.find(response)
    @photo_urls = []
    if !page.image_urls.blank?
      page.image_urls.each do |url|
        if !url.include?("Compass") && !url.include?("Ambox")
          @photo_urls << url
        end
      end
    end
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
