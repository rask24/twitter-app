class TweetsController < ApplicationController
  def index
    unless user_signed_in?
      authenticate_user!
    end
    @tweets = Tweet.all
    @new_tweet = Tweet.new
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)
    if @new_tweet.save
      redirect_to root_path
    else
      render 'index', status: :unprocessable_entity
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:text)
  end
end
