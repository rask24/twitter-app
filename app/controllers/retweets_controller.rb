class RetweetsController < ApplicationController
  def create
    if Retweet.create(user_id: retweet_params[:user_id], tweet_id: retweet_params[:tweet_id])
      if retweet_params[:from] == 'tweets_index'
        redirect_to root_path
      elsif retweet_params[:from] == 'users_show'
        redirect_to user_path(retweet_params[:page])
      end
    end
  end

  private
  def retweet_params
    params.permit(:id, :user_id, :tweet_id, :from, :page)
  end
end
