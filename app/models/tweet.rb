class Tweet < ApplicationRecord
  belongs_to :registered_tag

  validates :oembed, presence: true
end
