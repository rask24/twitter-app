# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to explore_tweets_path unless user_signed_in?
  end
end
