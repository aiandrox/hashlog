require 'rails_helper'

RSpec.describe Hashtag, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user_hashtags).class_name('UserHashtag') }
  end

  context 'validations' do
    before do
      create(:hashtag)
      build(:hashtag)
    end
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
