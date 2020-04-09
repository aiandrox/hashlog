FactoryBot.define do
  factory :tweet do
    content { 'ツイート内容' }
    registered_tag
  end
end
