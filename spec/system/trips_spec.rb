require "rails_helper"

RSpec.describe "Trips", type: :system do
  let(:user) { create(:user) }
  let(:trip) { create(:trip, user: user) }

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

    it "写真付きの遠征記録を作成できる" do
      visit new_trip_path

      fill_in "ライブ名", with: "写真付きLIVE"
      fill_in "開催日", with: "2026-09-17"
      fill_in "会場", with: "テスト会場"
      attach_file "写真を選択", Rails.root.join("spec/fixtures/files/test_image.png")

      expect do
        click_button "遠征記録を登録する"
      end.to change(Photo, :count).by(1)

      trip = Trip.last

      expect(trip.photos.count).to eq(1)
      expect(trip.photos.first.image).to be_present
    end

    it "複数の写真付きの遠征記録を作成できる" do
      visit new_trip_path

      fill_in "ライブ名", with: "複数写真LIVE"
      fill_in "開催日", with: "2026-09-17"
      fill_in "会場", with: "テスト会場"

      attach_file "写真を選択", [
        Rails.root.join("spec/fixtures/files/test_image.png"),
        Rails.root.join("spec/fixtures/files/test_image_2.png")
      ]

      expect do
        click_button "遠征記録を登録する"
      end.to change(Photo, :count).by(2)

      trip = Trip.last

      expect(trip.photos.count).to eq(2)
    end

    it "自分の遠征記録が一覧に表示される" do
      trip

      visit trips_path

      expect(page).to have_content trip.live_name
    end

    it "他のユーザーの遠征記録は一覧に表示されない" do
      other_user = create(:user)
      other_trip = create(:trip, user: other_user)

      visit trips_path

      expect(page).not_to have_content other_trip.live_name
    end

    it "遠征記録が開催日の新しい順に表示される" do
      create(:trip, user: user, live_name: "古いライブ", event_date: "2026-09-01")
      create(:trip, user: user, live_name: "新しいライブ", event_date: "2026-10-01")

      visit trips_path

      expect(page.body.index("新しいライブ")).to be < page.body.index("古いライブ")
    end

    it "自分の遠征記録の詳細が表示される" do
      trip.update!(
        live_name: "LIVE TOUR 2026",
        venue: "テスト会場",
        hotel: "テストホテル",
        transportation: "新幹線",
        ticket_cost: 10_000,
        transportation_cost: 8_000,
        accommodation_cost: 10_000,
        other_cost: 2_000,
        other_cost_memo: "食事代",
        memo: "最高のライブだった"
      )

      visit trip_path(trip)

      expect(page).to have_content "LIVE TOUR 2026"
      expect(page).to have_content "テスト会場"
      expect(page).to have_content "テストホテル"
      expect(page).to have_content "新幹線"
      expect(page).to have_content "10,000円"
      expect(page).to have_content "8,000円"
      expect(page).to have_content "2,000円"
      expect(page).to have_content "食事代"
      expect(page).to have_content "30,000円"
      expect(page).to have_content "最高のライブだった"
    end

    it "投稿した写真が詳細画面に表示される" do
      create(:photo, trip: trip)

      visit trip_path(trip)

     expect(page).to have_css("img.trip-photo", count: 1)
    end

    it "複数の写真が詳細画面に表示される" do
      create(:photo, trip: trip)
      create(:photo, trip: trip)

      visit trip_path(trip)

      expect(page).to have_css("img.trip-photo", count: 2)
    end

    it "他のユーザーの遠征記録は閲覧できない" do
      other_user = create(:user)
      other_trip = create(:trip, user: other_user)

      visit trip_path(other_trip)

      expect(page).to have_current_path(trips_path)
      expect(page).to have_content "遠征記録が見つかりません"
    end

    it "任意項目が未登録の場合は未登録と表示される" do
      trip.update!(
        hotel: nil,
        transportation: nil,
        ticket_cost: nil,
        transportation_cost: nil,
        accommodation_cost: nil,
        other_cost: nil,
        other_cost_memo: nil,
        memo: nil
      )

      visit trip_path(trip)

      expect(page).to have_content "未登録"
      expect(page).to have_content "0円"
    end

    it "自分の遠征記録の編集画面が表示される" do
      visit edit_trip_path(trip)

      expect(page).to have_field "ライブ名", with: trip.live_name
    end

    it "遠征記録を編集して保存できる" do
      visit edit_trip_path(trip)

      fill_in "ライブ名", with: "編集後のライブ"
      click_button "変更を保存する"

      expect(page).to have_current_path(trip_path(trip))
      expect(page).to have_content "遠征記録を更新しました"
      expect(page).to have_content "編集後のライブ"
    end

    it "編集画面から写真を追加できる" do
      visit edit_trip_path(trip)

      attach_file "写真を追加", Rails.root.join("spec/fixtures/files/test_image.png")

      expect do
        click_button "変更を保存する"
      end.to change(Photo, :count).by(1)

      expect(trip.reload.photos.count).to eq(1)
      expect(trip.photos.first.image).to be_present
    end

    it "編集画面から複数の写真を追加できる" do
      visit edit_trip_path(trip)

      attach_file "写真を追加", [
        Rails.root.join("spec/fixtures/files/test_image.png"),
        Rails.root.join("spec/fixtures/files/test_image_2.png")
      ]

      expect do
        click_button "変更を保存する"
      end.to change(Photo, :count).by(2)

      expect(trip.reload.photos.count).to eq(2)
    end

    it "自分の写真を削除でき、編集画面から表示されなくなる" do
      photo = create(:photo, trip: trip)

      visit edit_trip_path(trip)

      expect(page).to have_css("img.trip-photo", count: 1)

      expect do
        click_button "写真を削除"
      end.to change(Photo, :count).by(-1)

      expect(page).to have_current_path(edit_trip_path(trip))
      expect(page).to have_content "写真を削除しました"
      expect(page).not_to have_css("img.trip-photo")
    end

    it "他のユーザーの遠征記録は編集できない" do
      other_user = create(:user)
      other_trip = create(:trip, user: other_user)

      visit edit_trip_path(other_trip)

      expect(page).to have_current_path(trips_path)
      expect(page).to have_content "遠征記録が見つかりません"
    end

    it "必須項目が空の場合は遠征記録を更新できない" do
      visit edit_trip_path(trip)

      fill_in "ライブ名", with: ""
      click_button "変更を保存する"

      expect(page).to have_current_path(trip_path(trip))
      expect(trip.reload.live_name).not_to eq ""
    end

    it "自分の遠征記録を削除でき、一覧からも消える" do
      visit edit_trip_path(trip)

      expect do
        click_button "この記録を削除"
      end.to change(Trip, :count).by(-1)

      expect(page).to have_current_path(trips_path)
      expect(page).to have_content "遠征記録を削除しました"
      expect(page).not_to have_content trip.live_name
    end
  end

  context "ログインしていない場合" do
    it "遠征記録作成画面にアクセスできない" do
      visit new_trip_path

      expect(page).to have_current_path(new_user_session_path)
    end

    it "遠征記録一覧にアクセスできない" do
      visit trips_path

      expect(page).to have_current_path(new_user_session_path)
    end

    it "遠征記録詳細にアクセスできない" do
      visit trip_path(trip)

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
