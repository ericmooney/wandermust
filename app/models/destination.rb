class Destination < ActiveRecord::Base
  has_and_belongs_to_many :users

  reverse_geocoded_by :latitude, :longitude do |destination,results|
    if geo = results.first
      if geo != nil && geo.city != nil && geo.country != nil
        destination.address = "#{geo.city}, #{geo.country}"
        if destination.address == nil
          destination.address = 0
        end
      else
        destination.address = 0
      end
    else
      destination.address = 0
    end
  end
  after_validation :reverse_geocode

  attr_accessible :latitude, :longitude, :address, :user_id

  def get_random_coordinates
    update_attributes(:longitude => (rand*(360)-172), :latitude => (rand*(132)-66))
    return @destination
  end

end

