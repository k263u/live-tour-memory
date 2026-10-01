require "rails_helper"

RSpec.describe "Photos", type: :request do
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
    end
  end
end
