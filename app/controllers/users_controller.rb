class UsersController < ApplicationController
  def show
    # user / user tweets
    @user = User.find(user_params[:id])
    user_tweets = @user.tweets

    # followees / followers
    @followees = @user.follower_rels.map(&:followee)
    @followers = @user.followee_rels.map(&:follower)

    # new follow relation
    @new_follow = Follow.new

    # follow relation
    if user_signed_in?
      @is_others = current_user.id != @user.id
      @following_info = current_user.follower_rels.where(followee_id: @user.id)
    end

    # retweet
    user_retweets = @user.retweets

    # all tweets / retweets
    @tweets = user_tweets.to_a + user_retweets.to_a
    @tweets.sort_by! do |item|
      item.created_at
    end
    @tweets.reverse!
    @tweets.map! do |tw|
      is_retweet = tw.class.name == 'Retweet'
      rt = is_retweet ? tw : nil
      tw = is_retweet ? rt.tweet : tw
      {
        content: tw,
        retweet_info: rt,
        has_retweet: user_signed_in? ?
          tw.retweets.where(user_id: current_user.id).exists? : false,
        current_page: 'users_show_' + @user.id.to_s,
      }
    end


  end

  private
  def user_params
    params.permit(:id)
  end
end
