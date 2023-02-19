class TweetsController < ApplicationController
  def index
    if user_signed_in?
      followees_id = Follow.where(follower_id: current_user.id).map do |followee|
        followee.followee_id
      end
      @tweets = Tweet.where(user_id: followees_id).order(created_at: :desc)
      @followees = User.where(id: followees_id).order(created_at: :desc)
    else
      @tweets = Tweet.order(created_at: :desc).first(5)
    end
    @new_tweet = Tweet.new
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)
    if @new_tweet.save
      redirect_to root_path
    else
      @tweets = Tweet.order(created_at: :desc)
      render 'index', status: :unprocessable_entity
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:text)
  end
end