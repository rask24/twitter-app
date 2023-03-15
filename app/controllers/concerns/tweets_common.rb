# frozen_string_literal: true

module TweetsCommon
  extend ActiveSupport::Concern

  def tweets_list(tweets_array, current_page)
    tweets_array.sort_by!(&:created_at).reverse!
    tweets_array.map! do |tw|
      is_retweet = tw.instance_of?(Retweet)
      rt = is_retweet ? tw : nil
      tw = is_retweet ? rt.tweet : tw
      has_retweet = user_signed_in? ? tw.retweets.where(user_id: current_user.id).exists? : false
      tweet_item(tw, rt, has_retweet, tw.retweets.count, current_page)
    end
  end

  def tweet_item(content, retweet_info, has_retweet, retweet_count, current_page)
    {
      content:,
      retweet_info:,
      has_retweet:,
      retweet_count:,
      current_page:
    }
  end
end
