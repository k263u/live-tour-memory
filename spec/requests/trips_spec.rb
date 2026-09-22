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
end
