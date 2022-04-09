# == Schema Information
#
# Table name: registered_tags
#
#  id               :bigint           not null, primary key
#  first_tweeted_at :datetime
#  last_tweeted_at  :datetime
#  privacy          :integer          default("published"), not null
#  remind_day       :integer          default(0), not null
#  tweet_rate       :float(24)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tag_id           :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_registered_tags_on_created_at          (created_at)
#  index_registered_tags_on_tag_id              (tag_id)
#  index_registered_tags_on_user_id             (user_id)
#  index_registered_tags_on_user_id_and_tag_id  (user_id,tag_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
class RegisteredTagSerializer < ActiveModel::Serializer
  attributes :id, :tweeted_day_count, :privacy, :remind_day,
             :first_tweeted_at, :last_tweeted_at, :tweet_rate
  belongs_to :tag
  belongs_to :user

  def privacy
    object.privacy_i18n
  end

  def remind_day
    object.remind_day.zero? ? nil : object.remind_day
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :uuid, :name, :avatar_url
  end
end
