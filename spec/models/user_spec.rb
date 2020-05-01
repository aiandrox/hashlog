RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:authentications).dependent(:destroy) }
    it { is_expected.to have_many(:registered_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:registered_tags) }
  end

  describe 'validations' do
    before { create(:user) }
    it { is_expected.to validate_presence_of(:twitter_id) }
    it { is_expected.to validate_uniqueness_of(:twitter_id).case_insensitive }
    it { is_expected.to validate_presence_of(:screen_name) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
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
  end

  describe 'methods' do
    describe 'registered_tag(tag)' do
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

    describe 'register_tag(tag)' do
      let(:user) { create(:user, :real_value) }
      context 'tagが有効なとき' do
        let(:valid_tag) { build(:tag, name: 'ポートフォリオ進捗') }
        it 'trueを返す' do
          VCR.use_cassette('twitter_api/standard_search') do
            expect(user.register_tag(valid_tag)).to eq true
          end
        end
        it 'user.registered_tagが作成される' do
          VCR.use_cassette('twitter_api/standard_search') do
            expect { user.register_tag(valid_tag) }.to change(RegisteredTag, :count).by(1)
          end
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
      end
    end
  end
end
