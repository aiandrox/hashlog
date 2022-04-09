# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  avatar_url  :string(255)      default("https://abs.twimg.com/sticky/default_profile_images/default_profile.png"), not null
#  description :text(65535)
#  name        :string(255)      not null
#  privacy     :integer          default("published"), not null
#  role        :integer          default("general"), not null
#  screen_name :string(255)      not null
#  uuid        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  twitter_id  :string(255)      not null
#
# Indexes
#
#  index_users_on_twitter_id  (twitter_id) UNIQUE
#
RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has_one :authentications, destroy' do
      is_expected.to have_one(:authentication).dependent(:destroy)
    end
    it 'has_many :registered_tags, destroy' do
      is_expected.to have_many(:registered_tags).dependent(:destroy)
    end
    it 'has_many :tags, through :registered_tags' do
      is_expected.to have_many(:tags).through(:registered_tags)
    end
  end

  describe 'validations' do
    before { create(:user) }
    it 'twitter_id: presence' do
      is_expected.to validate_presence_of(:twitter_id)
    end
    it 'twitter_id: uniqueness' do
      is_expected.to validate_uniqueness_of(:twitter_id).case_insensitive
    end
    it 'screen_name: presence' do
      is_expected.to validate_presence_of(:screen_name)
    end
    it 'name: presence' do
      is_expected.to validate_presence_of(:name)
    end
    it 'name: length <50' do
      is_expected.to validate_length_of(:name).is_at_most(50)
    end
    it 'description: length <300' do
      is_expected.to validate_length_of(:description).is_at_most(300)
    end
  end

  describe 'default value' do
    let(:user) { create(:user) }
    it 'privacyがpublishedである' do
      expect(user.published?).to be_truthy
    end
    it 'roleがgeneralである' do
      expect(user.general?).to be_truthy
    end
    it '12字のuuidが生成されている' do
      expect(user.uuid.length).to eq 12
    end
    it 'avatar_urlがデフォルトのURLである' do
      expect(user.avatar_url).to eq 'https://abs.twimg.com/sticky/default_profile_images/default_profile.png'
    end
  end

  describe 'methods' do
    describe '#registered_tag(tag)' do
      let!(:user) { create(:user, :with_tags) }
      let(:registered_tag) { user.registered_tags.take }
      let(:user_tag) { registered_tag.tag }
      let(:other_tag) { create(:tag) }
      context '登録しているtagを渡すとき' do
        it '該当するregistered_tagを返す' do
          expect(user.registered_tag(user_tag)).to eq registered_tag
        end
      end
      context '登録していないtagを渡すとき' do
        it 'nilを返す' do
          expect(user.registered_tag(other_tag)).to eq nil
        end
      end
    end

    describe '#register_tag(tag)' do
      let(:user) { create(:user, :real_value) }
      context 'tagが有効なとき', vcr: { cassette_name: 'twitter_api/standard_search' } do
        let(:valid_tag) { build(:tag, name: 'ポートフォリオ進捗') }
        it 'trueを返す' do
          expect(user.register_tag(valid_tag)).to eq true
        end
        it 'user.registered_tagが作成される' do
          expect { user.register_tag(valid_tag) }.to change(RegisteredTag, :count).by(1)
        end
      end
      context 'tagが無効なとき' do
        let(:invalid_tag) { build(:tag, :invalid) }
        it 'falseを返す' do
          expect(user.register_tag(invalid_tag)).to eq false
        end
        it 'user.registered_tagが作成されない' do
          expect { user.register_tag(invalid_tag) }.not_to change(RegisteredTag, :count)
        end
        describe 'tag.errors.full_messagesの値' do
          context 'tag.name = ""のとき' do
            let(:tag) { build(:tag, name: '') }
            it '"名前を入力してください"を含む' do
              user.register_tag(tag)
              expect(tag.errors.full_messages).to include '名前を入力してください'
            end
          end
          context 'registered_tagが重複しているとき' do
            let(:tag) { build(:tag, name: '重複する名前') }
            it '"ハッシュタグは既に登録しています"を含む' do
              create(:registered_tag, user: user, tag: tag)
              user.register_tag(tag)
              expect(tag.errors.full_messages).to include 'ハッシュタグは既に登録しています'
            end
          end
          context '同一ユーザーのregistered_tagとして4つ目のとき' do
            let(:tag) { create(:tag) }
            it '"登録できるハッシュタグは3つまでです"を含む' do
              create_list(:registered_tag, 10, user: user)
              user.register_tag(tag)
              expect(tag.errors.full_messages).to include '登録できるハッシュタグは10個までです'
            end
          end
        end
      end
    end

    describe '#my_object?(object)' do
      context 'userのregistered_tagの場合' do
        let(:user) { create(:user) }
        let(:registered_tag) { create(:registered_tag, user: user) }
        it 'trueを返す' do
          expect(user.my_object?(registered_tag)).to be_truthy
        end
      end
      context 'userのregistered_tagではない場合' do
        let(:user) { create(:user) }
        let(:other_registered_tag) { create(:registered_tag) }
        it 'falseを返す' do
          expect(user.my_object?(other_registered_tag)).to be_falsey
        end
      end
      
    end

    describe '#replace_user_data' do
      let(:user) { create(:user) }
      it '保存時にdescriptionの最後の空白文字/改行が削除される' do
        text = "テキスト\n\n↑ここの改行は残したい\n↓は改行空白全て消してしまいたい。\n\n     \n\n\n　\n　\n　　　\n\n"
        user.update!(description: text)
        # 本当は"テキスト\n\n↑ここの改行は残したい\n↓は改行空白全て消してしまいたい。"を実装したい
        expect(user.reload.description).to eq "テキスト\n↑ここの改行は残したい\n↓は改行空白全て消してしまいたい。"
      end
      it 'avatar_urlの"_normal.拡張子"が".拡張子"に変換される' do
        types = %w[jpg jpeg gif png JPG JPEG GIF PNG]
        types.each do |type|
          avatar_url = "https://省略profile_normal.#{type}"
          expected_url = "https://省略profile.#{type}"
          user.update!(avatar_url: avatar_url)
          expect(user.reload.avatar_url).to eq expected_url
        end
      end
    end
  end
end
