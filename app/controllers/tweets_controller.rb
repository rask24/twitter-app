class TweetsController < ApplicationController
  def index
    if user_signed_in?
      # followee tweets
      followees_id = Follow.where(follower_id: current_user.id).map do |follow_rel|
        follow_rel.followee_id
      end
      followee_tweets = Tweet.where(user_id: followees_id)

      # followee retweets
      followee_retweets = Retweet.where(user_id: followees_id).to_a

      # all tweets to display
      @tweets = followee_tweets + followee_retweets
      @tweets.sort_by! do |tweet|
        tweet.created_at
      end
      @tweets.reverse!
      @tweets.map! do |tweet|
        if tweet.class.name == 'Tweet'
          {
            content: tweet,
            is_retweet: false,
            is_retweeted: Retweet.where(tweet_id: tweet.id, user_id: current_user.id).exists?
          }
        elsif tweet.class.name == 'Retweet'
          retweet = Tweet.find(tweet.tweet_id)
          {
            content: retweet,
            is_retweet: true,
            retweet_user_name: User.find(tweet.user_id).name,
            is_retweeted: Retweet.where(tweet_id: retweet.id, user_id: current_user.id).exists?
          }
        end
      end

      # new tweet / retweet
      @new_tweet = Tweet.new
      @new_retweet = Retweet.new

    else
      @tweets = Tweet.order(created_at: :desc).first(5)
    end
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)

    if @new_tweet.save
      redirect_to root_path
    else
      followees_id = Follow.where(follower_id: current_user.id).map do |followee|
        followee.followee_id
      end
      @tweets = Tweet.where(user_id: followees_id).order(created_at: :desc)
      @followees = User.where(id: followees_id).order(created_at: :desc)
      @new_tweet = Tweet.new
      @new_retweet = Retweet.new
      @is_retweeteds = @tweets.map do |tweet|
        Retweet.where(user_id: current_user.id, tweet_id: tweet.id).exists?
      end
      render 'index', status: :unprocessable_entity
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:text)
  end
end