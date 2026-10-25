require "rails_helper"

RSpec.describe "Trips", type: :request do
  describe "DELETE /trips/:id" do
    let(:user) { create(:user) }

    context "ログインしている場合" do
      let(:other_user) { create(:user) }
      let(:other_trip) { create(:trip, user: other_user) }

      before do
        post user_session_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "他のユーザーの遠征記録は削除できない" do
        other_trip

        expect do
          delete trip_path(other_trip)
        end.not_to change(Trip, :count)

        expect(response).to redirect_to(trips_path)
      end
    end

    context "ログインしていない場合" do
      let(:trip) { create(:trip, user: user) }

      it "遠征記録を削除できない" do
        trip

        expect do
          delete trip_path(trip)
        end.not_to change(Trip, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /trips" do
    let(:user) { create(:user) }

    before do
      post user_session_path, params: {
        email: user.email,
        password: "password"
      }
    end

    it "必須項目が未入力の場合、遠征記録を作成できない" do
      expect do
        post trips_path, params: {
          trip: {
            live_name: "",
            event_date: "",
            venue: ""
          }
        }
      end.not_to change(Trip, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "写真の保存に失敗した場合、遠征記録を作成せず日本語のエラーを表示する" do
      allow_any_instance_of(Photo).to receive(:save!).and_raise(
        ActiveRecord::RecordInvalid.new(Photo.new)
      )

      expect do
        post trips_path, params: {
          trip: {
            live_name: "TEST LIVE",
            event_date: "2026-10-25",
            venue: "東京ドーム",
            images: [
              fixture_file_upload("test_image.png", "image/png")
            ]
          }
        }
      end.not_to change(Trip, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("写真をアップロードできませんでした")
    end
  end

  describe "PATCH /trips/:id" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:other_trip) { create(:trip, user: other_user) }

    before do
      post user_session_path, params: {
        email: user.email,
        password: "password"
      }
    end

    it "他のユーザーの遠征記録を編集できない" do
      original_name = other_trip.live_name

      patch trip_path(other_trip), params: {
        trip: { live_name: "変更後のライブ名" }
      }

      expect(other_trip.reload.live_name).to eq(original_name)
      expect(response).to redirect_to(trips_path)
      expect(flash[:alert]).to eq("遠征記録が見つかりません")
    end

    it "存在しない遠征記録を編集できない" do
      patch trip_path(0), params: {
        trip: { live_name: "変更後のライブ名" }
      }

      expect(response).to redirect_to(trips_path)
      expect(flash[:alert]).to eq("遠征記録が見つかりません")
    end
  end
end
