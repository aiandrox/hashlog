# == Schema Information
#
# Table name: tweets
#
#  id                :bigint           not null, primary key
#  registered_tag_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  oembed            :text(65535)      not null
#  tweeted_at        :datetime         not null
#  tweet_id          :string(255)      not null
#
class TweetSerializer < ActiveModel::Serializer
  attributes :id, :tweet_id, :oembed, :tweeted_at
  has_many :images

  class ImageSerializer < ActiveModel::Serializer
    attributes :id, :src, :alt
  end
end
