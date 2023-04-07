# frozen_string_literal: true

class ExploreController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
