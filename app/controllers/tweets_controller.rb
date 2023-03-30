# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show destroy]

  def index
    @tweets = current_user.follow_tweets_retweets.page(params[:page])
  end

  def new
    @new_tweet = Tweet.new
    @new_retweet = Retweet.new
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)
    @new_tweet.save
    redirect_to root_path
  end

  def explore
    @tweets = Tweet.preload(:user, :retweets).order(created_at: :desc).page(params[:page])
  end

  def show
    @tweet = @tweet.tweet_detail(detail_params[:retweet_id])
  end

  def destroy
    @tweet.destroy
    tweets_redirect(detail_params[:from], detail_params[:user_id])
  end

  def retweets
    retweets = Retweet.where(tweet_id: detail_params[:id])
    @retweet_users_info = retweets.map do |rt|
      following_info = user_signed_in? ? Follow.find_by(follower_id: current_user.id, followee_id: rt.user.id) : nil
      {
        user: rt.user,
        following_info:,
        from: "tweets_retweets_#{detail_params[:id]}"
      }
    end
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

  def tweets_redirect(from, user_id)
    if from == 'tweets_index'
      redirect_to root_path
    elsif from == 'tweets_show'
      redirect_to user_path(user_id)
    elsif from.start_with?('users_show')
      redirect_to user_path(user_id)
    end
  end
end
