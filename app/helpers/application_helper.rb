module ApplicationHelper
  def top_destinations_list
    Destination.all.sort {
      |a, b| b.users.size <=> a.users.size
    }
  end

# Need to fix

  # def trending_destinations_list

  #   # need to contrain the array that I am sorting in the next section

  #   trending_favorites = Favorite.where(created_at: (Time.now - 3.hour)..Time.now)
  #   trending_array = []

  #   Destination.all.each do |x|
  #     if trending_favorites.include?(x)
  #       trending_array.push(x)
  #     end
  #   end

  #   trending_array.sort {
  #     |a, b| b.users.where(created_at: (Time.now - 3.hour)..Time.now).size <=>
  #     a.users.where(created_at: (Time.now - 3.hour)..Time.now).size
  #   }
  # end

end
