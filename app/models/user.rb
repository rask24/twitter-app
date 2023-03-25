# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets, dependent: :destroy
  has_many :follower_rels, class_name: 'Follow', foreign_key: :follower_id, inverse_of: 'follower', dependent: :destroy
  has_many :followee_rels, class_name: 'Follow', foreign_key: :followee_id, inverse_of: 'followee', dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :followers, through: :follower_rels, source: :followee
  has_many :followees, through: :followee_rels, source: :follower
  has_many :follower_tweets, through: :followers, source: :tweets
  has_many :follower_retweets, through: :followers, source: :retweets

  def self.tweets(user)
    user.tweets.to_a
  end

  def self.retweets(user)
    user.retweets.to_a
  end

  def self.followees(user)
    user.follower_rels.map(&:followee)
  end

  def self.followers(user)
    user.followee_rels.map(&:follower)
  end
end
