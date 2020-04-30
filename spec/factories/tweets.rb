FactoryBot.define do
  factory :tweet do
    oembed { '<blockquote class=\"twitter-tweet\"><p lang=\"ja\" dir=\"ltr\">今日は野菜ジュースでトマト風<br>具材は鶏むね、玉ねぎ、人参、チンゲン菜<a href=\"https://twitter.com/hashtag/%E8%87%AA%E7%82%8A?src=hash&amp;ref_src=twsrc%5Etfw\">#自炊</a> <a href=\"https://t.co/qxLHVr8Vj1\">pic.twitter.com/qxLHVr8Vj1</a></p>&mdash; END@wifi弱者 (@aiandrox) <a href=\"https://twitter.com/aiandrox/status/1248177348073025536?ref_src=twsrc%5Etfw\">April 9, 2020</a></blockquote>' }
    tweeted_at { DateTime.now }
    tweet_id { rand(10 ** 19).to_s }
    registered_tag
  end
end
