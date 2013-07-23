class Destination < ActiveRecord::Base
  has_many :users, through: :favorites
  has_many :favorites, dependent: :destroy

  attr_accessible :latitude, :longitude, :address, :user_id


  reverse_geocoded_by :latitude, :longitude do |destination,results|
    if geo = results.first
      if !geo.city.blank? && !geo.country.blank?
        destination.address = "#{geo.city}, #{geo.state}, #{geo.country}"
        if (destination.address.blank? || destination.address == "0" || destination.address == 0 || destination.address == "2" || destination.address == 2)
          destination.address = 0
        end
      else
        destination.address = 1
      end
    else
      destination.address = 2 #when this occurs, there is a potential error (query limit/etc) so needs special treatment
    end
  end
  after_validation :reverse_geocode


  def get_random_coordinates
    update_attributes(:longitude => (rand*(360)-180), :latitude => (rand*(180)-90))
    return  #without this, I was getting back "true"
  end

end

