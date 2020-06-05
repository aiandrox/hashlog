RSpec.describe Tag, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:registered_tags).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    before { create(:tag) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
  end

  describe 'scope' do
    describe '.popular' do
      let(:popular_tag) { create(:tag, name: 'the most popular tag') }
      let(:not_popular_tag) { create(:tag, name: 'not most popular tag') }
      before do
        create_list(:registered_tag, 5, tag: popular_tag)
        create_list(:registered_tag, 1, tag: not_popular_tag)
        create_list(:registered_tag, 3, tag: create(:tag))
      end
      it '紐付いたregistered_tagが多い順に並ぶ' do
        expect(Tag.popular.length).to eq 3
        expect(Tag.popular.first).to eq popular_tag
        expect(Tag.popular.last).to eq not_popular_tag
      end
    end
  end
end
