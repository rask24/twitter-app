class TweetsController < ApplicationController
  def index
    if user_signed_in?
      # tweetws / retweets
      followee_tweets = current_user.follower_rels.map(&:followee).map(&:tweets).flatten
      followee_retweets = current_user.follower_rels.map(&:followee).map(&:retweets).flatten

      # all tweets / retweets
      @tweets = followee_tweets + followee_retweets
      @tweets.sort_by! do |tweet|
        tweet.created_at
      end
      @tweets.reverse!
      @tweets.map! do |tw|
        is_retweet = tw.class.name == 'Retweet'
        rt = is_retweet ? tw : nil
        tw = is_retweet ? rt.tweet : tw
        {
          content: tw,
          retweet_info: rt,
          has_retweet: tw.retweets.where(user_id: current_user.id).exists?,
          current_page: 'tweets_index',
          page_id: nil,
        }
      end

      # new tweet / retweet
      @new_tweet = Tweet.new
      @new_retweet = Retweet.new

    else
      redirect_to explore_tweets_path
    end
  end

  def explore
      @tweets = Tweet.order(created_at: :desc).first(5)
  end

  def create
    @new_tweet = Tweet.new(text: tweet_params[:text], user_id: current_user.id)

    if @new_tweet.save
      redirect_to root_path
    else
      followee_tweets = current_user.follower_rels.map(&:followee).map(&:tweets).flatten
      followee_retweets = current_user.follower_rels.map(&:followee).map(&:retweets).flatten
     @tweets = followee_tweets + followee_retweets
      @tweets.sort_by! do |tweet|
        tweet.created_at
      end
      @tweets.reverse!
      @tweets.map! do |tw|
        is_retweet = tw.class.name == 'Retweet'
        rt = is_retweet ? tw : nil
        tw = is_retweet ? rt.tweet : tw
        {
          content: tw,
          retweet_info: rt,
          has_retweet: rt.nil? ?
            false : tw.retweets.where(user_id: current_user.id).exists?,
          current_page: 'tweets_index',
          page_id: nil,
        }
      end
      @new_tweet = Tweet.new
      @new_retweet = Retweet.new
      render 'index', status: :unprocessable_entity
    end
  end

  def destroy
    # tweet
    tweet = Tweet.find(params[:id])

    # retweet
    retweets = Retweet.where(tweet_id: tweet.id)

    # delete tweet / retweet
    retweets.each do |retweet|
      retweet.destroy
    end
    tweet.destroy

    # redirect
    if tweet_params[:from] == 'tweets_index'
      redirect_to root_path
    elsif tweet_params[:from] == 'users_show'
      redirect_to user_path(tweet_params[:page_id])
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:text, :page_id, :from)
  end
end