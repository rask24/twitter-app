# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  include TweetsCommon
  include FollowsCommon

  def show
    # followees / followers
    @followees = @user.follower_rels.map(&:followee)
    @followers = @user.followee_rels.map(&:follower)

    # new follow relation
    @new_follow = Follow.new

    # user info -> follow relation
    @user_info = follow_item(@user, "users_show_#{@user.id}")

    # all tweets / retweets
    @tweets = tweets_list(@user.tweets.to_a + @user.retweets.to_a, "users_show_#{@user.id}")
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

  private

  def set_user
    @user = User.find(user_params[:id])
  end

  def user_params
    params.permit(:id)
  end
end
