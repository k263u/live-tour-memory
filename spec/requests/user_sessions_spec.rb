require "rails_helper"

RSpec.describe "UserSessions", type: :request do
  describe "POST /user_session" do
    it "正しいメールアドレスとパスワードでログインできること" do
      user = create(:user)

      post user_session_path, params: {
        email: user.email,
        password: "password"
      }

      expect(response).to redirect_to(root_path)
    end

    it "パスワードが間違っている場合はログインできないこと" do
      user = create(:user)

      post user_session_path, params: {
        email: user.email,
        password: "wrongpassword"
      }

     expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /user_session" do
   it "ログアウトできること" do
     user = create(:user)

      post user_session_path, params: {
       email: user.email,
       password: "password"
      }

      delete user_session_path

     expect(response).to redirect_to(root_path)
    end
  end
end
