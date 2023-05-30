# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def show
    @tweets = @user.tweets_retweets.page params[:page]
  end

  def followers
    @followers = @user.followees
  end

  def followees
    @followees = @user.followers
  end

  def update
    redirect_to user_path(@user) if @user.update user_params
  end

  def profile
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit :icon, :name, :bio, :location, :website
  end
end
