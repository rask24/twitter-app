# frozen_string_literal: true

class RetweetsController < ApplicationController
  def create
    retweet = Retweet.new(user_id: current_user.id, tweet_id: retweet_params[:tweet_id])
    if retweet.save
      tweet = Tweet.find(retweet_params[:tweet_id])
      render_with_turbo_stream(tweet)
    end
  end

  def destroy
    retweet_to_del = Retweet.find(retweet_params[:id])
    if retweet_to_del.destroy
      tweet = Tweet.find(retweet_params[:tweet_id])
      render_with_turbo_stream(tweet)
    end
  end

  private

  def retweet_params
    params.permit(:id, :tweet_id)
  end

  def render_with_turbo_stream(tweet)
    render turbo_stream: [
      turbo_stream.replace_all(".retweet_button_#{retweet_params[:tweet_id]}",
                               partial: 'share/tweet_item_retweet_button',
                               locals: { tweet: }),
      turbo_stream.replace("retweet_button_detail_#{retweet_params[:tweet_id]}",
                           partial: 'share/tweet_item_retweet_button_detail',
                           locals: { tweet: })
    ]
  end
end
