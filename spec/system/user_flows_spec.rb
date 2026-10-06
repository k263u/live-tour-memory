require "rails_helper"

RSpec.describe "主要機能のユーザーフロー", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "ユーザー登録から遠征記録の操作まで一連の流れで行える" do
    visit new_user_path

    fill_in "名前", with: "テストユーザー"
    fill_in "メールアドレス", with: "flow@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード確認", with: "password"

    click_button "登録"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content "ユーザー登録が完了しました"

    visit new_user_session_path

    fill_in "メールアドレス", with: "flow@example.com"
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_current_path(trips_path)

    visit new_trip_path

    fill_in "ライブ名", with: "TEST LIVE"
    fill_in "開催日", with: "2026-10-06"
    fill_in "会場", with: "テスト会場"

    click_button "遠征記録を登録する"

    expect(page).to have_content "遠征記録を作成しました"
    expect(page).to have_content "TEST LIVE"
    expect(page).to have_content "テスト会場"

    click_link "TEST LIVE"

    expect(page).to have_current_path(trip_path(Trip.last))

    click_link "編集する"

    fill_in "ライブ名", with: "編集後のTEST LIVE"
    click_button "変更を保存する"

    expect(page).to have_content "遠征記録を更新しました"
    expect(page).to have_content "編集後のTEST LIVE"

    click_link "編集する"

    click_button "この記録を削除"

    expect(page).to have_current_path(trips_path)
    expect(page).to have_content "遠征記録を削除しました"
    expect(page).not_to have_content "編集後のTEST LIVE"
  end
end
