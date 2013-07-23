module ApplicationHelper

  #this one is not used anywhere at the moment
  def all_destinations_list
    Destination.all.sort {
      |a, b| a.address <=> b.address
    }
  end


  def top_destinations_list
    Destination.all.sort {
      |a, b| b.users.size <=> a.users.size
    }
  end

  def trending_destinations_list
    trending_favorites = Favorite.where(created_at: (Time.now - 15.hour)..Time.now)
    destinations = trending_favorites.map{|x| x.destination}
    sorted_trending = destinations.sort {|a, b| b.favorites.size <=> a.favorites.size}
    final = []

    sorted_trending.each do |destination|
      if !final.include?(destination)
        final << destination
      end
    end
    final
  end

  #for the "complete" page
  def most_recent_destinations_for_map
    arr = Destination.all.sort {
      |a, b| b.created_at <=> a.created_at
    }
    return arr[0..200]
  end


  def remove_footnote_tags(summary)
    summary.gsub("[update]","").gsub("[pronunciation?]","").gsub("[citation needed]","").gsub("[1]","").gsub("[2]","").gsub("[3]","").gsub("[4]","").gsub("[5]","").gsub("[6]","").gsub("[7]","").gsub("[8]","").gsub("[9]","").gsub("[10]","").gsub("[11]","").gsub("[12]","").gsub("[13]","").gsub("[14]","").gsub("[15]","").gsub("[16]","").gsub("[17]","").gsub("[18]","").gsub("[19]","").gsub("[20]","").gsub("[21]","").gsub("[22]","").gsub("[23]","").gsub("[24]","").gsub("[25]","").gsub("[26]","").gsub("[27]","").gsub("[28]","").gsub("[29]","").gsub("[30]","").gsub("[31]","").gsub("[32]","").gsub("[33]","").gsub("[34]","").gsub("[35]","").gsub("[36]","").gsub("[37]","").gsub("[38]","")
  end
end

