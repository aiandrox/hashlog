# == Schema Information
#
# Table name: images
#
#  id       :bigint           not null, primary key
#  alt      :string(255)      not null
#  src      :string(255)      not null
#  tweet_id :bigint           not null
#
class Image < ApplicationRecord
  belongs_to :tweet
end
