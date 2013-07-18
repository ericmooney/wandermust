module ApplicationHelper
  def top_destinations_list
    Destination.all.sort {
      |a, b| b.users.size <=> a.users.size
    }
  end

  # Need to fix

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

end

