class TweetSerializer < ActiveModel::Serializer
  attributes :id, :tweet_id, :oembed, :tweeted_at
  has_many :images

  class ImageSerializer < ActiveModel::Serializer
    attributes :id, :src, :alt
  end
end
