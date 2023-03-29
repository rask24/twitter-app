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

  def tweets_retweets
    relation = Tweet.joins("LEFT OUTER JOIN retweets
                            ON tweets.id = retweets.tweet_id
                            AND retweets.user_id = #{id}")
                    .select('tweets.*,
                             retweets.id AS retweet_id,
                             retweets.user_id AS retweet_user_id,
                             retweets.created_at AS retweet_created_at')
    relation.where(user_id: id)
            .or(relation.where('retweets.user_id = ?', id))
            .preload(:user, :retweet_user, :retweets)
            .order(Arel.sql('CASE WHEN retweets.created_at IS NULL
                             THEN tweets.created_at
                             ELSE retweets.created_at
                             END DESC'))
  end

  def follow_tweets_retweets
    relation = Tweet.joins("LEFT OUTER JOIN retweets
                            ON tweets.id = retweets.tweet_id
                            AND retweets.user_id
                            IN (SELECT followee_id FROM follows WHERE follows.follower_id = #{id})")
                    .select('tweets.*,
                             retweets.id AS retweet_id,
                             retweets.user_id AS retweet_user_id,
                             retweets.created_at AS retweet_created_at')
    relation.where(id: Retweet.where(user_id: followers.pluck(:id)).pluck(:tweet_id))
            .or(relation.where(user_id: followers.pluck(:id)))
            .preload(:user, :retweet_user, :retweets)
            .order(Arel.sql('CASE WHEN retweets.created_at IS NULL THEN tweets.created_at
                             ELSE retweets.created_at
                             END DESC'))
  end
end
