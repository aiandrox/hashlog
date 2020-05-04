class TweetSerializer < ActiveModel::Serializer
  attributes :id, :tweet_id, :oembed, :tweeted_at
end
