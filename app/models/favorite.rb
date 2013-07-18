class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :destination

  attr_accessible :user_id, :destination_id

  def self.trending_destinations_list
    list_favorites = Favorite.where(created_at: (Time.now - 12.hour)..Time.now)
    trending_destinations = {}

    list_favorites.each do |favorite|
      destination = favorite.destination
      if !trending_destinations.include?(destination.id)
        trending_destinations[destination.id] = 1
      else
        binding.pry
        trending_destinations[destination.id] = trending_destinations[destination.id] + 1
      end
    end
    trending_destinations
  end
end
