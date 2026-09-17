require "rails_helper"

RSpec.describe Trip, type: :model do
  describe "バリデーション" do
    it "必要な項目があれば有効である" do
      trip = build(:trip)

      expect(trip).to be_valid
    end

    it "ライブ名がなければ無効である" do
      trip = build(:trip, live_name: nil)

      expect(trip).to be_invalid
    end

    it "開催日がなければ無効である" do
      trip = build(:trip, event_date: nil)

      expect(trip).to be_invalid
    end

    it "会場がなければ無効である" do
      trip = build(:trip, venue: nil)

      expect(trip).to be_invalid
    end
  end

  describe "関連付け" do
    it "Userに紐づいている" do
      trip = create(:trip)

      expect(trip.user).to be_present
    end
  end
end
