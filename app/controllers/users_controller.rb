class UsersController < ApplicationController
  def show
    @user = User.find(user_params[:id])

    @my_tweets = Tweet.order(created_at: :desc).where(user_id: user_params[:id])

    followees_id = Follow.where(follower_id: @user.id).map do |followee|
      followee.followee_id
    end
    @followees = User.where(id: followees_id).order(created_at: :desc)

    followers_id = Follow.where(followee_id: @user.id).map do |follower|
      follower.follower_id
    end
    @followers = User.where(id: followers_id).order(created_at: :desc)
    @new_follow = Follow.new

    if user_signed_in?
      @is_others = current_user.id != @user.id
      @is_following = false
      @follow_rel_id = nil
      Follow.where(follower_id: current_user.id).each do |rel|
        if rel.followee_id == @user.id
          @is_following = true
          @follow_rel_id = rel.id
        end
      end
    end

  end

  private
  def user_params
    params.permit(:id)
  end
end
