require "rails_helper"

RSpec.describe Photo, type: :model do
  describe "Tripとの関連付け" do
    it "Tripに紐づいたPhotoを作成できること" do
      trip = create(:trip)
      photo = create(:photo, trip: trip)

      expect(photo.trip).to eq(trip)
    end
  end

  describe "画像アップロード" do
    it "画像をアップロードして保存できること" do
      photo = create(:photo)

      expect(photo.image).to be_present
      expect(photo.image.file).to be_present
    end

    it "1つのTripに複数の写真を保存できること" do
      trip = create(:trip)

      create(:photo, trip: trip)
      create(:photo, trip: trip)

      expect(trip.photos.count).to eq(2)
    end
  end
end
