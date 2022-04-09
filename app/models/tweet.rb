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
class Tweet < ApplicationRecord
  belongs_to :registered_tag
  has_many :images, dependent: :destroy

  validates :oembed, presence: true
  validates :tweet_id, presence: true
  validates :tweet_id, uniqueness: { case_sensitive: false, scope: :registered_tag_id }
  validates :tweeted_at, presence: true

  after_create :set_tweets_date_to_registered_tag

  scope :desc, -> { order(tweeted_at: :desc) }
  scope :tweeted_day_count, lambda {
    formated_date = "date_format(tweeted_at, '%Y%m%d')"
    select(formated_date).group(formated_date).length
  }
  scope :tweeted_ats, -> { select(:tweeted_at) }
  scope :tweeted_at_date, ->(date) { where(tweeted_at: date.beginning_of_day..date.end_of_day) }

  def self.latest
    desc.first
  end

  def self.oldest
    desc.last
  end

  def self.create_with_images!(oembed:, tweeted_at:, tweet_id:, medias:)
    ActiveRecord::Base.transaction do
      tweet = create!(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)

      medias&.each do |media|
        tweet.images.find_or_create_by!(
          alt: tweet.registered_tag.tag.name,
          src: media.media_url.to_s
        )
      end
    end
  end

  private

  def set_tweets_date_to_registered_tag
    registered_tag.update!(
      first_tweeted_at: registered_tag.tweets.oldest&.tweeted_at,
      last_tweeted_at: registered_tag.tweets.latest&.tweeted_at
    )
  end
end
