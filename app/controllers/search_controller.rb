# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @search = Tweet.preload(:user, :retweets).ransack(params[:q])
    @tweets = @search.result.order(id: :desc).page(params[:page])
  end

  def new
    @search = Tweet.preload(:user, :retweets).ransack(params[:q])
  end
end
