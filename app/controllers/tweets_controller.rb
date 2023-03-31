# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show destroy retweets]

  def index
    @tweets = current_user.follow_tweets_retweets.page(params[:page])
  end

  def new
    @new_tweet = Tweet.new
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)
    @new_tweet.save
    redirect_to root_path
  end

  def show
    @tweet = @tweet.tweet_detail(detail_params[:retweet_id])
  end

  def destroy
    @tweet.destroy
  end

  def retweets
    @retweet_users = @tweet.retweet_users
  end

  private

  def tweet_params
    params.require(:tweet).permit(:text)
  end

  def detail_params
    params.permit(:id, :user_id, :from, :retweet_id)
  end

  def set_tweet
    @tweet = Tweet.find(detail_params[:id])
  end
end
