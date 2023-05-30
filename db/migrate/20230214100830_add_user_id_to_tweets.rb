# frozen_string_literal: true

class AddUserIdToTweets < ActiveRecord::Migration[7.0]
  def change
    add_reference :tweets, :user, foreign_key: true
  end
end
