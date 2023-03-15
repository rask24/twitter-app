# frozen_string_literal: true

class FollowsController < ApplicationController
  def create
    Follow.create(follower_id: follow_params[:follower_id],
                  followee_id: follow_params[:followee_id])
    follows_redirect(follow_params[:from], follow_params[:followee_id])
  end

  def destroy
    follow_rel = Follow.find(follow_params[:id])
    follow_rel.destroy
    follows_redirect(follow_params[:from], follow_rel.followee_id)
  end

  private

  def follow_params
    params.permit(:follower_id, :followee_id, :id, :user_id, :from)
  end

  def follows_redirect(from, followee_id)
    if from.start_with?('users_show')
      redirect_to user_path(followee_id)
    elsif from.start_with?('tweets_retweets')
      redirect_to retweets_tweet_path(from.delete('^0-9'))
    elsif from.start_with?('users_followee')
      redirect_to followees_user_path(from.delete('^0-9'))
    elsif from.start_with?('users_follower')
      redirect_to followers_user_path(from.delete('^0-9'))
    end
  end
end
