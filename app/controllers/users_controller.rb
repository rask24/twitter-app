class UsersController < ApplicationController
  def show
    # user info
    @user = User.find(user_params[:id])
    user_tweets = Tweet.where(user_id: user_params[:id]).order(created_at: :desc)

    # followee info
    followees_id = Follow.where(follower_id: @user.id).map do |followee|
      followee.followee_id
    end
    @followees = User.where(id: followees_id).order(created_at: :desc)

    # follower info
    followers_id = Follow.where(followee_id: @user.id).map do |follower|
      follower.follower_id
    end
    @followers = User.where(id: followers_id).order(created_at: :desc)
    @new_follow = Follow.new

    # follow relation
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
    
    # retweet
    user_retweets = Retweet.where(user_id: @user.id)
    @tweets = user_tweets.to_a + user_retweets.to_a
    @tweets.sort_by! do |item|
      item.created_at
    end
    @tweets.reverse!
    if user_signed_in?
      @tweets.map! do |tweet|
        if tweet.class.name == 'Tweet'
          {
            content: tweet,
            is_retweet: false,
            is_retweeted: Retweet.where(user_id: current_user.id, tweet_id: tweet.id).exists?
          }
        elsif tweet.class.name == 'Retweet'
          retweet = Tweet.find(tweet.tweet_id)
          {
            content: retweet,
            is_retweet: true,
            is_retweeted: Retweet.where(user_id: current_user.id, tweet_id: retweet.id).exists?
          }
        end
      end
    else
      @tweets.map! do |tweet|
        if tweet.class.name == 'Tweet'
          {
            content: tweet,
            is_retweet: false
          }
        elsif tweet.class.name == 'Retweet'
          retweet = Tweet.find(tweet.tweet_id)
          {
            content: retweet,
            is_retweet: true
          }
        end
      end
    end

  end

  private
  def user_params
    params.permit(:id)
  end
end
