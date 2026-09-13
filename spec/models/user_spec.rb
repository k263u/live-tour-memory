require "rails_helper"

RSpec.describe User, type: :model do
  it "FactoryBotでユーザーを作成できること" do
    user = create(:user)

    expect(user).to be_persisted
  end

  it "nameがない場合は無効であること" do
    user = build(:user, name: nil)

    expect(user).to be_invalid
  end

  it "emailがない場合は無効であること" do
    user = build(:user, email: nil)

    expect(user).to be_invalid
  end

  it "emailが重複している場合は無効であること" do
    user = create(:user)
    duplicate_user = build(:user, email: user.email)

    expect(duplicate_user).to be_invalid
  end

  it "passwordが7文字以下の場合は無効であること" do
    user = build(:user, password: "1234567", password_confirmation: "1234567")

    expect(user).to be_invalid
  end

  it "password_confirmationが一致しない場合は無効であること" do
    user = build(
      :user,
      password: "password",
      password_confirmation: "passwors"
    )

    expect(user).to be_invalid
  end

  it "passwordがない場合は無効であること" do
    user = build(:user, password: nil)

    expect(user).to be_invalid
  end

  it "password_confirmationがない場合は無効であること" do
    user = build(:user, password_confirmation: nil)

    expect(user).to be_invalid
  end
end
