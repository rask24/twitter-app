# frozen_string_literal: true

class RetweetsController < ApplicationController
  def create
    retweet = Retweet.new(user_id: current_user.id, tweet_id: retweet_params[:tweet_id])
    retweet.save
    render turbo_stream: turbo_stream.update_all(".retweet_button_#{retweet_params[:tweet_id]}",
                                             partial: 'share/tweet_item_retweet_button',
                                             locals: { tweet: Tweet.find(retweet_params[:tweet_id]) })
  end

  def destroy
    retweet_to_del = Retweet.find(retweet_params[:id])
    retweet_to_del.destroy
    render turbo_stream: turbo_stream.update_all(".retweet_button_#{retweet_params[:tweet_id]}",
                                             partial: 'share/tweet_item_retweet_button',
                                             locals: { tweet: Tweet.find(retweet_params[:tweet_id]) })
  end

  private

  def retweet_params
    params.permit(:id, :user_id, :tweet_id, :from, :retweet_id)
  end
end
