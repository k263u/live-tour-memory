require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "正しい情報でユーザー登録できること" do
      expect do
        post users_path, params: {
          user: {
            name: "テストユーザー",
            email: "test@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "不正な情報ではユーザー登録できないこと" do
     expect do
      post users_path, params: {
        user: {
         name: "",
         email: "",
         password: "",
         password_confirmation: ""
        }
      }
    end.not_to change(User, :count)

    expect(response).to have_http_status(:unprocessable_entity)
   end
  end
end
