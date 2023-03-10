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

    # user info -> follow relation
    following_info = user_signed_in? ? current_user.follower_rels.find_by(followee_id: @user.id) : nil
    @user_info = {
      user: @user,
      following_info: following_info,
      from: 'users_show_' + @user.id.to_s,
    }

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
        retweet_count: tw.retweets.count,
        current_page: 'users_show_' + @user.id.to_s,
      }
    end
  end

  def followers
    # フォロワー
    user = User.find(user_params[:id])
    @followers_info = user.followee_rels.map do |f|
      f_user = f.follower
      following_info = user_signed_in? ? Follow.find_by(follower_id: current_user.id, followee_id: f_user.id) : nil
      {
        user: f.follower,
        following_info: following_info,
        from: 'users_followers_' + user.id.to_s,
      }
    end
  end

  def followees
    # フォロー中
    user = User.find(user_params[:id])
    @followees_info = user.follower_rels.map do |f|
      f_user = f.followee
      following_info = user_signed_in? ? Follow.find_by(follower_id: current_user.id, followee_id: f_user.id) : nil
      {
        user: f.followee,
        following_info: following_info,
        from: 'users_followers_' + user.id.to_s,
      }
    end
  end

  private
  def user_params
    params.permit(:id)
  end
end
