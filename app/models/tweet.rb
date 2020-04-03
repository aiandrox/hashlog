class Tweet < ApplicationRecord
  belongs_to :registered_tag

  validates :content, presence: true
end
