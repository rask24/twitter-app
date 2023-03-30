# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  include FollowsCommon

  def show
    @tweets = @user.tweets_retweets.page(params[:page])
  end

  def followers
    # フォロワー
    @followers = @user.followees
  end

  def followees
    # フォロー中
    @followees = @user.followers
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
