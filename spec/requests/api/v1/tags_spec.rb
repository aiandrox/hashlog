RSpec.describe 'Tags', type: :request do
  describe 'GET /api/v1/tags' do
    let(:popular_tag) { create(:tag) }
    let(:tags) { Tag.popular }
    let(:tags_json) { json['tags'] }
    describe '全般的なこと' do
      before do
        create_list(:registered_tag, 3, tag: popular_tag)
        create_list(:registered_tag, 10)
        get '/api/v1/tags'
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'Tag.popularのJSONを返す' do
        tags_json.zip(tags).each do |tag_json, tag|
          expect(tag_json).to eq({
            'id' => tag.id,
            'name' => tag.name,
          })
        end
      end
      it 'tagsが人気順に並ぶ' do
        expect(tags_json.first['id']).to eq popular_tag.id
      end
    end
    context 'countクエリがないとき' do
      before do
        create_list(:registered_tag, 50)
        get '/api/v1/tags'
      end
      describe 'pagy' do
        it 'pageクエリがないとき 20件返す' do
          expect(tags_json.length).to eq 20
        end
        it 'page=2のとき 20件返す' do
          get '/api/v1/tags?page=2'
          expect(tags_json.length).to eq 20
        end
      end
    end
    context 'countクエリがあるとき' do
      let(:count) { rand(1..5) }
      before do
        create_list(:registered_tag, 10)
        get "/api/v1/tags?count=#{count}"
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'countで指定したレコード数を返す' do
        expect(tags_json.length).to eq count
      end
    end
  end
end
