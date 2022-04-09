# == Schema Information
#
# Table name: images
#
#  id       :bigint           not null, primary key
#  alt      :string(255)      not null
#  src      :string(255)      not null
#  tweet_id :bigint           not null
#
# Indexes
#
#  index_images_on_tweet_id  (tweet_id)
#
# Foreign Keys
#
#  fk_rails_...  (tweet_id => tweets.id)
#
class Image < ApplicationRecord
  belongs_to :tweet
end
