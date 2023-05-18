# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

NUM_OF_USERS = 100
NUM_OF_TWEETS = 500
NUM_OF_FOLLOWS = 100
MAX_NUM_OF_RETWEETS = 30

NUM_OF_USERS.times do |_i|
  name = Faker::Internet.username
  User.create name:, email: Faker::Internet.email, password: name
end

NUM_OF_TWEETS.times do |_i|
  Tweet.create text: Faker::Lorem.sentence, user_id: rand(1...NUM_OF_USERS)
end

NUM_OF_USERS.times do |i|
  user_follows = rand(1...NUM_OF_FOLLOWS)
  user_follows.times do |j|
    Follow.create(follower_id: i + 1, followee_id: j)
  end
end

NUM_OF_USERS.times do |i|
  user_retweets = rand(1...MAX_NUM_OF_RETWEETS)
  shuffled_tweet_ids = (1...NUM_OF_TWEETS).to_a.shuffle
  user_retweets.times do |j|
    Retweet.create(user_id: i + 1, tweet_id: shuffled_tweet_ids[j])
  end
end
