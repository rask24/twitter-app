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
      @tweets = Tweet.order(created_at: :desc).first(20)
      @tweets.map! do |tw|
        {
          content: tw,
          retweet_info: nil,
          has_retweet: user_signed_in? ? tw.retweets.where(user_id: current_user.id).exists? : false,
          current_page: 'tweets_explore',
        }
      end
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
          # has_retweet: rt.nil? ? false : tw.retweets.where(user_id: current_user.id).exists?,
          has_retweet: tw.retweets.where(user_id: current_user.id).exists?,
          current_page: 'tweets_index',
        }
      end
      @new_tweet = Tweet.new
      @new_retweet = Retweet.new
      render 'index', status: :unprocessable_entity
    end
  end

  def show
    tw = Tweet.find(detail_params[:id])
    rt = detail_params[:retweet_id].nil? ? nil : Retweet.find(detail_params[:retweet_id])
    @tweet = {
      content: tw,
      retweet_info: rt,
      has_retweet: tw.retweets.where(user_id: current_user.id).exists?,
      current_page: 'tweets_show',
    }
  end

  def destroy
    # tweet
    tweet = Tweet.find(detail_params[:id])

    # retweet
    retweets = Retweet.where(tweet_id: tweet.id)

    # delete tweet / retweet
    retweets.each do |retweet|
      retweet.destroy
    end
    tweet.destroy

    # redirect
    if detail_params[:from] == 'tweets_index'
      redirect_to root_path
    elsif detail_params[:from] == 'tweets_show'
      redirect_to user_path(detail_params[:user_id])
    elsif detail_params[:from] == 'users_show'
    redirect_to user_path(detail_params[:user_id])
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:text)
  end

  def detail_params
    params.permit(:id, :user_id, :from, :retweet_id)
  end
end