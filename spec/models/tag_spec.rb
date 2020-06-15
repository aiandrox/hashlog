RSpec.describe Tag, type: :model do
  describe 'associations' do
    it 'has_many :registered_tags, restrict_with_error' do
      is_expected.to have_many(:registered_tags).dependent(:restrict_with_error)
    end
  end

  describe 'validations' do
    before { create(:tag) }
    it 'name: presence' do
      is_expected.to validate_presence_of(:name)
    end
    it 'name: uniqueness' do
      is_expected.to validate_uniqueness_of(:name)
    end
    it 'name: length <100' do
      is_expected.to validate_length_of(:name).is_at_most(100)
    end
    describe 'name: hashtag_format' do
      context '正常系' do
        it 'ひらがな' do
          is_expected.to allow_value('ひらがな', 'ぁ').for(:name)
        end
        it 'カタカナ' do
          is_expected.to allow_value('カタカナ', 'ヴ').for(:name)
        end
        it '漢字' do
          is_expected.to allow_value('漢字', '々').for(:name)
        end
        it 'Alphabet' do
          is_expected.to allow_value('Alphabet', 'A', 'aaa').for(:name)
        end
        it '123半角数字と文字' do
          is_expected.to allow_value('123半角数字と文字', '1あ2あ3').for(:name)
        end
        it '１２３全角数字と文字' do
          is_expected.to allow_value('１２３全角数字と文字', '1２３あ').for(:name)
        end
        it '_゛゜と文字' do
          is_expected.to allow_value('_文字_', '゛゛あ゛', '゜゜あ゜').for(:name)
        end
      end
      context '異常系' do
        it '記号混じり' do
          is_expected.not_to allow_value('あ#あ', 'あ@あ', 'あ-あ', 'あ。あ', 'あ、あ', 'あ,あ', 'あ.あ').for(:name)
        end
        it '数字のみ' do
          is_expected.not_to allow_value('111', '１１１').for(:name)
        end
        it '_゛゜のみ' do
          is_expected.not_to allow_value('_', '___', '゛', '゜').for(:name)
        end
        it 'ああ あ（スペース混じり）' do
          is_expected.not_to allow_value('あ　あ', 'あ あ', ' あ', '　あ').for(:name)
        end
      end
    end
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

  describe 'methods' do
    describe '#remove_first_hashtag_mark' do
      # tagのバリデーションのための部分は上の'name: hashtag_format'の項目でテストする
      context '先頭に#が入っているとき' do
        let(:tag) { build(:tag, name: '#ハッシュタグ') }
        it '#を消した文字列になる' do
          tag.save!
          expect(tag.name).to eq 'ハッシュタグ'
        end
      end
      context '先頭に###が入っているとき' do
        let(:tag) { build(:tag, name: '###ハッシュタグ') }
        it '###を消した文字列になる' do
          tag.save!
          expect(tag.name).to eq 'ハッシュタグ'
        end
      end
      context 'aa#aaのように文の途中で#が入っているとき' do
        let(:tag) { build(:tag, name: 'ハッシュ##タグ') }
        it '#を消さない' do
          tag.save!
          expect(tag.name).to eq 'ハッシュ##タグ'
        end
      end
    end
  end
end
