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

  describe "#total_cost" do
    it "各費用の合計を返す" do
      trip = build(
        :trip,
        ticket_cost: 10_000,
        transportation_cost: 15_000,
        accommodation_cost: 8_000,
        other_cost: 2_000
      )

      expect(trip.total_cost).to eq 35_000
    end

    it "未入力の費用があっても0円として計算する" do
      trip = build(
        :trip,
        ticket_cost: 10_000,
        transportation_cost: nil,
        accommodation_cost: 8_000,
        other_cost: nil
      )

      expect(trip.total_cost).to eq 18_000
    end
  end
end
