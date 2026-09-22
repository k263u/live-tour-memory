FactoryBot.define do
  factory :trip do
    association :user
    live_name { "LIVE TOUR 2026" }
    artist_name { "テストアーティスト" }
    event_date { Date.new(2026, 9, 17) }
    venue { "テスト会場" }
    hotel { "テストホテル" }
    transportation { "電車" }
    ticket_cost { 12_000 }
    transportation_cost { 20_000 }
    accommodation_cost { 15_000 }
    other_cost { 3_000 }
    other_cost_memo { "食事代" }
    memo { "楽しかった！" }
  end
end
