class Tag < ApplicationRecord
  before_validation :remove_first_hashtag_mark

  has_many :registered_tags, dependent: :restrict_with_error
  has_many :users, through: :registered_tags

  validates :name, format: { with: /\A[Ａ-Ｚａ-ｚA-Za-z一-龠々0-9０-９ぁ-ヶｦ-ﾟー゛゜_]+\Z/,
                             message: 'の入力形式が不適です' }
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

  # TODO: 警告を直す
  scope :popular, -> { joins(:registered_tags).group(:tag_id).order('count(user_id) DESC') }

  private

  def remove_first_hashtag_mark
    name&.gsub!(/^#+/, '')
    # 数字_゛゜だけの場合はバリデーションで弾くために、'@'に置き換える。ゴリ押しっぽいけど…
    name&.gsub!(/\A[\d０-９゛゜_]+\Z/, '@')
  end
end
