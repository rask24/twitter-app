# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :tweets, dependent: :destroy
  has_many :follower_rels, class_name: 'Follow', foreign_key: :follower_id, inverse_of: 'follower', dependent: :destroy
  has_many :followee_rels, class_name: 'Follow', foreign_key: :followee_id, inverse_of: 'followee', dependent: :destroy
  has_many :retweets, dependent: :destroy
end
