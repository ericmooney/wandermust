class DestinationsController < ApplicationController
  require "open-uri"
  require 'wikipedia'

  skip_before_filter :require_authentication
  skip_before_filter :require_admin_authentication

  def index
  end

  def complete
    @destinations = Destination.all
  end

  def create
    # Goal: Use Geocoder to pull back a city, if no city returns, create new random coordinates

    @destination = Destination.new

    #in case the geocoder fails, only try this many times before breaking loop
    max_geocode_fails = 15

    #get random coordinates, which also triggers geocoder gem reverse geocode
    @destination.get_random_coordinates

    # make sure the destination has a valid city returned, and if it doesn't, just delete destination and try again
    #in future, see if I can do this before saving a record to DB
    if [0,1,2,"0","1","2"].include?(@destination.address)
      counter = 1
      until ( ![0,1,2,"0","1","2"].include?(@destination.address) || counter == max_geocode_fails )
        @destination.destroy
        @destination = Destination.new
        @destination.get_random_coordinates
        counter = counter + 1
      end
    end

    # geocoder configured to google only allows 2500 q/day apparently. consider a different config

    # if it does fail/max out, leverage the existing db
    if counter == max_geocode_fails
      @destination.destroy

      #pick a random destination from the DB instead
      all_saved_ids = []
      destinations = Destination.all

      destinations.each do |destination|
        all_saved_ids << destination.id
      end
      @destination = Destination.find(all_saved_ids.sample)
    end

    respond_to do |format|
      #if we hit the limit due to geocoder fail, don't overwrite the existing db destination by saving it.
      if counter == max_geocode_fails
        format.html { redirect_to @destination }
        format.js
      else
        if @destination.save
          format.html { redirect_to @destination }
          format.js
        else
          format.html { render action: "index" }
          format.js
        end
      end
    end
  end

  def show
    @destination = Destination.find(params[:id])

    if !session[:user_id].blank?  #only used to see if the favorite is owned by logged in user
      @user = User.find(session[:user_id])
    end

    begin
      response = RubyWebSearch::Google.search(:query => "#{@destination.address} site:en.wikipedia.org").results.first[:url]
      if response.include?("User")
        raise
      end
      wiki_content = Nokogiri::HTML(open(response))
      summary = wiki_content.css("#mw-content-text p")[0].content
      if (summary.blank? || summary.include?("Coordinates") || summary.include?("www") || summary.length < 52)
        summary = wiki_content.css("#mw-content-text p")[1].content
        if (summary.include?("may refer to") || summary.blank? || summary.include?("Coordinates") || summary.include?("www"))
          raise
        else
          @summary = summary
        end
      else
        @summary = summary
      end
    rescue
      begin
        response = RubyWebSearch::Google.search(:query => "#{@destination.address.split(", ")[0]}, #{@destination.address.split(", ")[2]} site:en.wikipedia.org").results.first[:url]
        if response.include?("User")
          raise
        end
        wiki_content = Nokogiri::HTML(open(response))
        summary = wiki_content.css("#mw-content-text p")[0].content
        if (summary.blank? || summary.include?("Coordinates") || summary.include?("www") || summary.length < 52)
          summary = wiki_content.css("#mw-content-text p")[1].content
          if (summary.include?("may refer to") || summary.blank? || summary.include?("Coordinates") || summary.include?("www"))
            raise
          else
            @summary = summary
          end
        else
          @summary = summary
        end
      rescue
        begin
          response = RubyWebSearch::Google.search(:query => "#{@destination.address.split(", ")[1]}, #{@destination.address.split(", ")[2]} site:en.wikipedia.org").results.first[:url]
          if response.include?("User")
            raise
          end
          wiki_content = Nokogiri::HTML(open(response))
          summary = wiki_content.css("#mw-content-text p")[0].content
          if (summary.blank? || summary.include?("Coordinates") || summary.include?("www") || summary.length < 52)
            summary = wiki_content.css("#mw-content-text p")[1].content
            if (summary.include?("may refer to") || summary.blank? || summary.include?("Coordinates") || summary.include?("www"))
              raise
            else
              @summary = summary
            end
          else
            @summary = summary
          end
        rescue
          begin
            wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[0].titleize.gsub(" ", "_")}"))
            summary = wiki_content.css("#mw-content-text p")[0].content
            if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to") || summary.include?("www") || summary.length < 52)
              summary = wiki_content.css("#mw-content-text p")[1].content
              if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to"))
                raise
              else
                @summary = summary
              end
            else
              @summary = summary
            end
          rescue
            begin
              wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[0].titleize.split(" ")[0]}"))
              summary = wiki_content.css("#mw-content-text p")[0].content
              if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to") || summary.include?("www") || summary.length < 52)
                summary = wiki_content.css("#mw-content-text p")[1].content
                if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to"))
                  raise
                else
                  @summary = summary
                end
              else
                @summary = summary
              end
            rescue
              begin
              wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[1].titleize.gsub(" ", "_")}"))
              summary = wiki_content.css("#mw-content-text p")[0].content
              if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to") || summary.include?("www") || summary.length < 52)
                summary = wiki_content.css("#mw-content-text p")[1].content
                if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to"))
                  raise
                else
                  @summary = summary
                end
              else
                @summary = summary
              end
              rescue
                begin
                wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[1].titleize.split(" ")[0]}"))
                summary = wiki_content.css("#mw-content-text p")[0].content
                if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to") || summary.include?("www") || summary.length < 52)
                  summary = wiki_content.css("#mw-content-text p")[1].content
                  if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to"))
                    raise
                  else
                    @summary = summary
                  end
                else
                  @summary = summary
                end
                rescue
                  begin
                  wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[2].titleize.gsub(" ", "_")}"))
                  summary = wiki_content.css("#mw-content-text p")[0].content
                  if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to") || summary.include?("www") || summary.length < 52)
                    summary = wiki_content.css("#mw-content-text p")[1].content
                    if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to"))
                      raise
                    else
                      @summary = summary
                    end
                  else
                    @summary = summary
                  end
                  rescue
                    wiki_content = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{@destination.address.split(", ")[2].titleize.split(" ")[0]}"))
                    summary = wiki_content.css("#mw-content-text p")[0].content
                    if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to") || summary.include?("www") || summary.length < 52)
                      summary = wiki_content.css("#mw-content-text p")[1].content
                      if (summary.blank? || summary.include?("Coordinates") || summary.include?("may refer to"))
                        raise
                      else
                        @summary = summary
                      end
                    else
                      @summary = summary
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    if !response.nil?
      page = Wikipedia.find(response)
      @photo_urls = []
      if !page.image_urls.blank?
        p = page.image_urls
        p.reject!{|url| url == nil }
        p.each do |url|
          if !url.include?("Compass") && !url.include?("Ambox") && !url.include?("A-") && !url.include?("Magnify")
            @photo_urls << url
          end
        end
      end
    end

  end

  def save
    @destination = Destination.find(params[:id])

    if !session[:user_id].blank?  #if the session has started i.e. the customer is logged in
      @user = User.find(session[:user_id])  #grab the user object
      if !@user.destinations.include?(@destination)
        @user.destinations << @destination #push destination into bridge table
      else
        flash[:alert] = "That favorite is already in your list."
      end
      redirect_to user_path(@user)
    else
      @user = User.new
      @destination = Destination.find(params[:id]) #if not logged in, grab the destination object to be used after the login..
      render new_session_path
    end
  end

end
