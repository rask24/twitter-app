# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to explore_index_path unless user_signed_in?
  end
end
