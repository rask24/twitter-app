# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :text, presence: true, length: { maximum: 140 }
  belongs_to :user
  has_many :retweets, dependent: :destroy

  def self.followee_tweets(current_user)
    current_user.follower_rels.map(&:followee).map(&:tweets).flatten
  end

  def self.followee_retweets(current_user)
    current_user.follower_rels.map(&:followee).map(&:retweets).flatten
  end
end
