# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  include TweetsCommon
  include FollowsCommon

  def show
    # new follow relation
    @new_follow = Follow.new

    # user info -> follow relation
    @user_info = follow_item(@user, "users_show_#{@user.id}")

    # all tweets / retweets
    @tweets = @user.tweets_retweets.page(params[:page])
  end

  def followers
    # フォロワー
    @followers_info = @user.followee_rels.map do |f|
      follow_item(f.follower, "users_followers_#{@user.id}")
    end
  end

  def followees
    # フォロー中
    @followees_info = @user.follower_rels.map do |f|
      follow_item(f.followee, "users_followees_#{@user.id}")
    end
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def profile; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :bio, :location, :website)
  end
end
