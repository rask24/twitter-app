# frozen_string_literal: true

class Tweet < ApplicationRecord
  validates :text, presence: true, length: { maximum: 140 }
  belongs_to :user
  belongs_to :retweet_user, class_name: 'User', optional: true
  has_many :retweets, dependent: :destroy

  def retweet_info(user_id)
    retweets.find_by(user_id:)
  end

  def tweet_detail(retweet_id)
    relation = Tweet.joins('LEFT OUTER JOIN retweets
                            ON tweets.id = retweets.tweet_id')
                    .select('tweets.*,
                              retweets.id AS retweet_id,
                              retweets.user_id AS retweet_user_id,
                              retweets.created_at AS retweet_created_at')
                    .preload(:user, :retweet_user, :retweets)
                    .where(id:)
    retweet_id.present? ? relation.find_by(retweets: { id: retweet_id }) : relation[0]
  end
end
