class TagUser < ApplicationRecord
  belongs_to :user
  belongs_to :tag
  belongs_to :tag_log
end
