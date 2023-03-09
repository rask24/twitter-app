class RetweetsController < ApplicationController
  def create
    tweet_info = Tweet.find(retweet_params[:tweet_id])
    retweet = Retweet.new(user_id: current_user.id, tweet_id: retweet_params[:tweet_id])
    if retweet.save
      if retweet_params[:from] == 'tweets_index'
        redirect_to root_path
      elsif retweet_params[:from] == 'tweets_explore'
        redirect_to explore_tweets_path
      elsif retweet_params[:from] == 'tweets_show'
        if retweet_params[:retweet_id].empty?
          redirect_to tweet_path(retweet_params[:tweet_id])
        else
          redirect_to tweet_path(retweet_params[:tweet_id], retweet_id: retweet_params[:retweet_id])
        end
      elsif retweet_params[:from].start_with?('users_show')
        redirect_to user_path(retweet_params[:from].delete('^0-9'))
      end
    end
  end

  def destroy
    retweet_to_del = Retweet.find(retweet_params[:id])
    retweet_info = Retweet.find_by(id: retweet_params[:retweet_id])
    if retweet_to_del.destroy
      if retweet_params[:from] == 'tweets_index'
        redirect_to root_path
      elsif retweet_params[:from] == 'tweets_explore'
        redirect_to explore_tweets_path
      elsif retweet_params[:from] == 'tweets_show'
        if retweet_params[:retweet_id].empty? || retweet_info.user_id == current_user.id
          redirect_to tweet_path(retweet_params[:tweet_id])
        else
          redirect_to tweet_path(retweet_params[:tweet_id], retweet_id: retweet_params[:retweet_id])
        end
      elsif retweet_params[:from].start_with?('users_show')
        redirect_to user_path(retweet_params[:from].delete('^0-9'))
      end
    end
  end

  private
  def retweet_params
    params.permit(:id, :user_id, :tweet_id, :from, :retweet_id)
  end
end
