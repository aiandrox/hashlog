class Tweet < ApplicationRecord
  # include TwitterClient

  belongs_to :registered_tag

  validates :oembed, presence: true

  # def self.auto_save!
  #   tweet_results.each do |oembed, tweeted_at|
  #     create!(oembed: oembed, tweeted_at: tweeted_at)
  #   end
  # end

  # この以下3つのメソッドはtwitter_client関係として切り分けたい。
  # def tweet_results
  #   @tweet_ids = []
  #   @tweeted_ats = []
  #   standard_search
  #   @tweet_oembeds ||= client.oembeds(@tweet_ids, omit_script: true)
  #                                    .take(100)
  #                                    .map(&:html)
  #   @tweet_oembeds.zip(@tweeted_ats)
  # end

  # def standard_search
  #   client.search("##{tag.name} from:#{user.screen_name}",
  #                         result_type: 'recent').take(100).each do |result|
  #     @tweeted_ats << result.created_at
  #     @tweet_ids << result.id
  #   end
  # end

  # def primium_search
  #   client.premium_search("##{tag.name} from:#{user.screen_name}",
  #                                 { maxResults: 100 },
  #                                 { product: '30day' }).take(100).collect do |result|
  #     @tweeted_ats << result.created_at
  #     @tweet_ids << result.id
  #   end
  # end
end
