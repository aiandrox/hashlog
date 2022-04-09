# == Schema Information
#
# Table name: tweets
#
#  id                :bigint           not null, primary key
#  oembed            :text(65535)      not null
#  tweeted_at        :datetime         not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  registered_tag_id :bigint
#  tweet_id          :string(255)      not null
#
# Indexes
#
#  index_tweets_on_registered_tag_id               (registered_tag_id)
#  index_tweets_on_tweet_id_and_registered_tag_id  (tweet_id,registered_tag_id) UNIQUE
#  index_tweets_on_tweeted_at                      (tweeted_at)
#
# Foreign Keys
#
#  fk_rails_...  (registered_tag_id => registered_tags.id)
#
class TweetSerializer < ActiveModel::Serializer
  attributes :id, :tweet_id, :oembed, :tweeted_at
  has_many :images

  class ImageSerializer < ActiveModel::Serializer
    attributes :id, :src, :alt
  end
end
