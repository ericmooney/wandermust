class Destination < ActiveRecord::Base
  has_and_belongs_to_many :users

  attr_accessible :lat, :long
end
