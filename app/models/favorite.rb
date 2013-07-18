class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :destination

  attr_accessible :user_id, :destination_id
end
