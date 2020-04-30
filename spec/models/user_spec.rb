RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:authentications).dependent(:destroy) }
    it { is_expected.to have_many(:registered_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:registered_tags) }
  end

  describe 'validations' do
    before do
      create(:user)
      build(:user)
    end
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

  fdescribe 'methods' do
    let(:user) { create(:user, :with_tags) }
    let(:registered_tag) { user.registered_tags.take }
    let(:user_tag) { registered_tag.tag }
    let(:other_tag) { create(:tag) }
    describe 'registered_tag(tag)' do
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
  end
end
