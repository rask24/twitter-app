class FollowsController < ApplicationController
  def create
    if Follow.create(follower_id: follow_params[:follower_id], followee_id: follow_params[:followee_id])
      if follow_params[:from].start_with?('users_show')
        redirect_to user_path(follow_params[:followee_id])
      elsif follow_params[:from].start_with?('tweets_retweets')
        redirect_to retweets_tweet_path(follow_params[:from].delete('^0-9'))
      end
    end
  end

  def destroy
    @follow_rel = Follow.find(follow_params[:id])
    if @follow_rel.destroy
      if follow_params[:from].start_with?('users_show')
        redirect_to user_path(follow_params[:from].delete('^0-9')), status: :see_other
      elsif follow_params[:from].start_with?('tweets_retweets')
        redirect_to retweets_tweet_path(follow_params[:from].delete('^0-9'))
      end
    end
  end
  
  private
  def follow_params
    params.permit(:follower_id, :followee_id, :id, :user_id, :from)
  end
end