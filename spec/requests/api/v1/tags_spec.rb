RSpec.describe 'Tags', type: :request do
  describe 'GET /api/v1/tags' do
    let(:tags) { Tag.all }
    let(:tags_json) { json['tags'] }
    before do
      create_list(:registered_tag, 3)
      get '/api/v1/tags'
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'Tag.allのJSONを返す' do
      expect(tags_json.length).to eq 3
      tags_json.zip(tags).each do |tag_json, tag|
        expect(tag_json).to eq({
          'id' => tag.id,
          'name' => tag.name,
        })
      end
    end
    xit 'tagsが降順に並ぶ' do # 並び順は今のところ指定なし。強いて言うなら人気順になる気がする。
      expect(tags_json.first['id']).to eq oldest_registered_tag.id
      expect(tags_json.last['id']).to eq latest_registered_tag.id
    end
  end
end
