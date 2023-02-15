class UsersController < ApplicationController
  def show
    @user = User.find(user_params[:id])
    @my_tweets = Tweet.order(created_at: :desc).where(user_id: user_params[:id])
  end

  private
  def user_params
    params.permit(:id)
  end
end
