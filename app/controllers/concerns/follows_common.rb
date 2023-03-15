# frozen_string_literal: true

module FollowsCommon
  extend ActiveSupport::Concern

  def follow_item(user, from)
    following_info = user_signed_in? ? current_user.follower_rels.find_by(followee_id: user.id) : nil
    {
      user:,
      following_info:,
      from:
    }
  end
end
