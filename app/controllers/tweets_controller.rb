# frozen_string_literal: true

class TweetsController < ApplicationController
  include TweetsCommon

  def index
    redirect_to explore_tweets_path unless user_signed_in?
    # all tweets / retweets
    @tweets = tweets_list(Tweet.followee_tweets(current_user) + Tweet.followee_retweets(current_user), 'tweets_index')
    @tweets = Kaminari.paginate_array(@tweets).page(params[:page])

    # new tweet / retweet
    @new_tweet = Tweet.new
    @new_retweet = Retweet.new
  end

  def explore
    top_tweets = Tweet.order(created_at: :desc).to_a
    @tweets = tweets_list(top_tweets, 'tweets_explore')
    @tweets = Kaminari.paginate_array(@tweets).page(params[:page])
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)
    @new_tweet.save
    redirect_to root_path
  end

  def show
    tw = Tweet.find(detail_params[:id])
    rt = Retweet.find_by(id: detail_params[:retweet_id])
    hr = user_signed_in? ? tw.retweets.where(user_id: current_user.id).exists? : false
    rc = tw.retweets.count
    @tweet = tweet_item(tw, rt, hr, rc, 'tweets_show')
  end

  def destroy
    # tweet / retweet
    tweet = Tweet.find(detail_params[:id])

    # delete tweet / retweet
    tweet.destroy
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
