class HashtagUser < ApplicationRecord
  belongs_to :user
  belongs_to :hashtag
  belongs_to :hashtag_log
end
