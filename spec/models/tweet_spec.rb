RSpec.describe Tweet, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:registered_tag) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:oembed) }
    it { is_expected.to validate_presence_of(:tweet_id) }
  end
end
