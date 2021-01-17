module TwitterAPI
  class AddImages
    include TwitterAPIClient

    def self.call(tweet)
      new.call(tweet)
    end

    def call(tweet)
      @user = tweet.registered_tag.user
      create_images(tweet)
    end

    private

    attr_reader :user

    def twitter_medias(tweet)
      @twitter_medias ||=
        client(user).status(tweet.tweet_id).media.filter { |media| media.type == 'photo' }
    end

    def create_images(tweet)
      twitter_medias(tweet).each do |media|
        tweet.images.find_or_create_by!(
          alt: tweet.registered_tag.tag.name,
          src: media.media_url.to_s
        )
      rescue StandardError => e
        puts "ID: #{tweet.id} 追加失敗\n#{e}"
      end
    end
  end
end
