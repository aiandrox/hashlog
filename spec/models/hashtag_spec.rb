require 'rails_helper'

RSpec.describe Hashtag, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:hashtag_users) }
    it { is_expected.to have_many(:users).through(:hashtag_users) }
  end

  context 'validations' do
    before do
      create(:hashtag)
      build(:hashtag)
    end
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
  end
end
