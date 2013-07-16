class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many :destinations

  attr_accessible :email, :first_name, :password, :password_confirmation, :destination_id

  validates :email, :uniqueness => true
end
