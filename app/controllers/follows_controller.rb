class FollowsController < ApplicationController
  def create
    if Follow.create(follow_params)
      redirect_to user_path(follow_params[:followee_id])
    end
  end

  def destroy
    @follow_rel = Follow.find(follow_params[:id])
    puts '+++++++++++++++++++++++'
    p follow_params
    puts '+++++++++++++++++++++++'
    if @follow_rel.destroy
      redirect_to user_path(follow_params[:user_id]), status: :see_other
    end
  end
  
  private
  def follow_params
    params.permit(:follower_id, :followee_id, :id, :user_id)
  end
end