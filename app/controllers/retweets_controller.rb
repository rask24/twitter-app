# frozen_string_literal: true

class RetweetsController < ApplicationController
  def create
    retweet = Retweet.new(user_id: current_user.id, tweet_id: retweet_params[:tweet_id])
    retweet.save
    tweet = Tweet.find(retweet_params[:tweet_id])
    render turbo_stream: [
      turbo_stream.replace_all(".retweet_button_#{retweet_params[:tweet_id]}",
                                                  partial: 'share/tweet_item_retweet_button',
                                                  locals: { tweet: tweet }),
      turbo_stream.replace("retweet_button_detail_#{retweet_params[:tweet_id]}", partial: 'share/tweet_item_retweet_button_detail', locals: { tweet: tweet })
    ]
  end

  def destroy
    retweet_to_del = Retweet.find(retweet_params[:id])
    retweet_to_del.destroy
    tweet = Tweet.find(retweet_params[:tweet_id])
    render turbo_stream: [
      turbo_stream.replace_all(".retweet_button_#{retweet_params[:tweet_id]}",
                                                  partial: 'share/tweet_item_retweet_button',
                                                  locals: { tweet: tweet }),
      turbo_stream.replace("retweet_button_detail_#{retweet_params[:tweet_id]}", partial: 'share/tweet_item_retweet_button_detail', locals: { tweet: tweet })
    ]
  end

  private

  def retweet_params
    params.permit(:id, :tweet_id)
  end
end
