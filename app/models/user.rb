class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets
  has_many :follower_rels, class_name: 'Follow', foreign_key: :follower_id
  has_many :followee_rels, class_name: 'Follow', foreign_key: :followee_id
  has_many :retweets
end
