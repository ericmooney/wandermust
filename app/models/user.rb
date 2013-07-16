class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many :destinations

  attr_accessible :email, :first_name, :password, :password_confirmation, :destination_id

  validates :email, :uniqueness => true

  validates_presence_of :first_name
  validates_presence_of :email
  validates_presence_of :password, :on => :create
end
