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
  end

  context "ログインしていない場合" do
    it "遠征記録作成画面にアクセスできない" do
      visit new_trip_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
