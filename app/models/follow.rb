class Follow < ApplicationRecord
  validates :follower_id, presence: true
  validates :followee_id, presence: true
  validates :follower_id, uniqueness: { scope: :followee_id }
end
