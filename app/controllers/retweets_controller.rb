# frozen_string_literal: true

class RetweetsController < ApplicationController
  def create
    retweet = Retweet.new(user_id: current_user.id, tweet_id: retweet_params[:tweet_id])
    retweet.save
    retweets_redirect(retweet_params[:from],
                      retweet_params[:tweet_id],
                      retweet_params[:retweet_id])
  end

  def destroy
    retweet_to_del = Retweet.find(retweet_params[:id])
    retweet_to_del.destroy
    retweets_redirect(retweet_params[:from],
                      retweet_params[:tweet_id],
                      retweet_params[:retweet_id])
  end

  private

  def retweet_params
    params.permit(:id, :user_id, :tweet_id, :from, :retweet_id)
  end

  def retweets_redirect(from, tweet_id, retweet_id)
    if from == '/tweets'
      redirect_to root_path
    elsif from == '/tweets/explore'
      redirect_to explore_tweets_path
    elsif from.start_with?('/tweets/')
      redirect_to tweet_path(tweet_id, retweet_id:)
    elsif from.start_with?('/users/')
      redirect_to user_path(from.delete('^0-9'))
    end
  end
end
