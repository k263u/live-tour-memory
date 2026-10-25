require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "ログインしている場合" do
      let(:user) { create(:user) }

      before do
        post user_session_path, params: {
          email: user.email,
          password: "password"
        }
      end

      it "遠征記録一覧へリダイレクトする" do
        get root_path

        expect(response).to redirect_to(trips_path)
      end
    end

    context "ログインしていない場合" do
      it "TOPページを表示する" do
        get root_path

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
