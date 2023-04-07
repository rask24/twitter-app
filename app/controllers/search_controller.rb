# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @search = Tweet.ransack(params[:q])
    @tweets = @search.result.preload(:user, :retweets).order(id: :desc).page(params[:page])
  end

  def new
    @search = Tweet.ransack(params[:q])
  end
end
