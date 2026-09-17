FactoryBot.define do
  factory :trip do
    association :user
    live_name { "LIVE TOUR 2026" }
    artist_name { "テストアーティスト" }
    event_date { Date.new(2026, 9, 17) }
    venue { "テスト会場" }
    hotel { "テストホテル" }
    transportation { "電車" }
    cost { 50_000 }
    memo { "楽しかった！" }
  end
end
