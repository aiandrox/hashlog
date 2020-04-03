FactoryBot.define do
  factory :tweet do
    content { "MyString" }
    media_url { "MyString" }
    registered_tag { nil }
  end
end
