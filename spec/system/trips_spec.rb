require "rails_helper"

RSpec.describe "Trips", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  context "ログインしている場合" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end

    it "遠征記録を作成できる" do
      visit new_trip_path

      fill_in "ライブ名", with: "LIVE TOUR 2026"
      fill_in "開催日", with: "2026-09-17"
      fill_in "会場", with: "テスト会場"

      expect do
        click_button "遠征記録を登録する"
      end.to change(Trip, :count).by(1)

      expect(page).to have_content "遠征記録を作成しました"
    end

    it "自分の遠征記録が一覧に表示される" do
      create(:trip, user: user, live_name: "自分のライブ")

      visit trips_path

      expect(page).to have_content "自分のライブ"
    end

    it "他のユーザーの遠征記録は一覧に表示されない" do
      other_user = create(:user)
      create(:trip, user: other_user, live_name: "他のユーザーのライブ")

      visit trips_path

      expect(page).not_to have_content "他のユーザーのライブ"
    end

    it "遠征記録が開催日の新しい順に表示される" do
      create(:trip, user: user, live_name: "古いライブ", event_date: "2026-09-01")
      create(:trip, user: user, live_name: "新しいライブ", event_date: "2026-10-01")

      visit trips_path

      expect(page.body.index("新しいライブ")).to be < page.body.index("古いライブ")
    end

    it "自分の遠征記録の詳細が表示される" do
      trip = create(:trip, user: user, live_name: "LIVE TOUR 2026", venue: "テスト会場", hotel: "テストホテル", transportation: "新幹線", cost: 30000, memo: "最高のライブだった")

      visit trip_path(trip)

      expect(page).to have_content "LIVE TOUR 2026"
      expect(page).to have_content "テスト会場"
      expect(page).to have_content "テストホテル"
      expect(page).to have_content "新幹線"
      expect(page).to have_content "30,000円"
      expect(page).to have_content "最高のライブだった"
    end

    it "他のユーザーの遠征記録は閲覧できない" do
      other_user = create(:user)
      other_trip = create(:trip, user: other_user)

      visit trip_path(other_trip)

      expect(page).to have_current_path(trips_path)
      expect(page).to have_content "遠征記録が見つかりません"
    end

    it "任意項目が未登録の場合は未登録と表示される" do
      trip = create(:trip, user: user, hotel: nil, transportation: nil, cost: nil, memo: nil)

      visit trip_path(trip)

      expect(page).to have_content("未登録", count: 4)
    end
  end

  context "ログインしていない場合" do
    it "遠征記録作成画面にアクセスできない" do
      visit new_trip_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
