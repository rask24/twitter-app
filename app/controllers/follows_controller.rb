# frozen_string_literal: true

class FollowsController < ApplicationController
  def create
    @user = User.find(follow_params[:followee_id])
    Follow.create(follower_id: follow_params[:follower_id],
                  followee_id: follow_params[:followee_id])
    render_with_turbo_stream
  end

  def destroy
    follow_rel = Follow.find(follow_params[:id])
    @user = User.find(follow_rel.followee_id)
    follow_rel.destroy
    render_with_turbo_stream
  end

  private

  def follow_params
    params.permit(:follower_id, :followee_id, :id)
  end

  def render_with_turbo_stream
    render turbo_stream: [
      turbo_stream.replace("follow_button_#{@user.id}", partial: 'users/user_follow_button'),
      turbo_stream.replace(:follower_count, partial: 'users/user_follower_count')
    ] and return
  end
end
