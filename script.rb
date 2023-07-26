# frozen_string_literal: true

tw = Tweet.find_by text: 'hello'
tw.retweets
tw.retweet_users
