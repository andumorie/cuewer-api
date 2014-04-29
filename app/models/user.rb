class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :friendships, dependent: :destroy
  has_many :friends, :through => :friendships, dependent: :destroy
end
