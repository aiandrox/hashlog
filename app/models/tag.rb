# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  before_validation :remove_first_hashtag_mark

  has_many :registered_tags, dependent: :restrict_with_error
  has_many :users, through: :registered_tags

  validates :name, format: { with: /\A[Ａ-Ｚａ-ｚA-Za-z一-龠々0-9０-９ぁ-ヶｦ-ﾟー゛゜_]+\Z/,
                             message: 'の入力形式が不適です' }
  validates :name, presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 100 }

  scope :popular, -> { joins(:registered_tags).group(:tag_id).order(Arel.sql('count(user_id) DESC')) }

  private

  def remove_first_hashtag_mark
    name&.gsub!(/^#+/, '')
    # 数字_゛゜だけの場合はバリデーションで弾くために、'@'に置き換える。ゴリ押しっぽいけど…
    name&.gsub!(/\A[\d０-９゛゜_]+\Z/, '@')
  end
end
