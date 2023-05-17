# frozen_string_literal: true

class AddFollowerIdAndFolloweeIdToFollows < ActiveRecord::Migration[7.0]
  def change
    add_index :follows, %i[follower_id followee_id], unique: true
  end
end
