module TwitterAPI
  class Update
    include TwitterApiClient
    include ActiveModel::Validations

    attr_reader :user, :tag, :body
    attr_writer :tweet_id, :tweeted_at

    validates :body, presence: true, length: { maximum: 140 }
    validate :include_hashtag

    def initialize(user:, tag:, body:)
      @user = user
      @tag = tag
      @body = body
    end

    # return ["<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-13 07:13:39 UTC, 1249596597479956481]
    def call
      return false if invalid?

      # 叙述的に書かないとTwitter::Error::NotFoundになる
      oembed = client(user).oembeds(tweet_id, omit_script: true, hide_thread: true, lang: :ja)
      oembed.first.html =~ %r{" dir="ltr">(.+)</p>}
      tweet_oembed = Regexp.last_match(-1)
      [tweet_oembed, tweeted_at, tweet_id]
    rescue Twitter::Error::DuplicateStatus
      errors.add(:base, '同一内容の投稿はできません')
      false
    end

    def include_hashtag
      return if body.blank?

      errors.add(:base, 'ツイートにハッシュタグを含んでいません') unless body.include?("##{tag.name}")
    end

    private

    def tweet_data
      @tweet_data ||= client(user).update!(body)
    end

    def tweet_id
      tweet_data.id
    end

    def tweeted_at
      tweet_data.created_at
    end
  end
end
