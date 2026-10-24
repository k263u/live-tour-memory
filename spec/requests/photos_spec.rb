
require "rails_helper"

RSpec.describe "Photos", type: :request do
  describe "GET /photos/:id" do
    let(:user) { create(:user) }
    let(:trip) { create(:trip, user: user) }
    let(:photo) { create(:photo, trip: trip) }

    before do
      post user_session_path, params: {
        email: user.email,
        password: "password"
      }
    end

    it "自分の写真を表示できる" do
      get photo_path(photo)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to start_with("image/")
    end

    it "他のユーザーの写真は表示できない" do
      other_user = create(:user)
      other_trip = create(:trip, user: other_user)
      other_photo = create(:photo, trip: other_trip)

      get photo_path(other_photo)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /photos/:id" do
    let(:user) { create(:user) }

    context "ログインしている場合" do
      let(:other_user) { create(:user) }
      let(:other_trip) { create(:trip, user: other_user) }
      let(:other_photo) { create(:photo, trip: other_trip) }

      before do
        post user_session_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "他のユーザーの写真は削除できない" do
        other_photo

        expect do
          delete photo_path(other_photo)
        end.not_to change(Photo, :count)

        expect(response).to redirect_to(trips_path)
      end

      it "存在しない写真は削除できない" do
        expect do
          delete photo_path(id: 999_999)
        end.not_to change(Photo, :count)

        expect(response).to redirect_to(trips_path)
        expect(flash[:alert]).to eq("写真が見つかりません")
      end
    end

    context "ログインしていない場合" do
      let(:trip) { create(:trip, user: user) }
      let(:photo) { create(:photo, trip: trip) }

      it "写真を削除できない" do
        photo

        expect do
          delete photo_path(photo)
        end.not_to change(Photo, :count)

        expect(response).to redirect_to(new_user_session_path)
      end

      it "ログインしていない場合は写真を表示できない" do
        delete user_session_path

        get photo_path(photo)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
