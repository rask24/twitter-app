# frozen_string_literal: true

class Follow < ApplicationRecord
  validates :follower_id, uniqueness: { scope: :followee_id }
  belongs_to :follower, class_name: 'User', inverse_of: 'follower_rels'
  belongs_to :followee, class_name: 'User', inverse_of: 'followee_rels'
end
