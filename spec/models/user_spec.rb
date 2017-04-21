require 'rails_helper'

describe User do

  subject(:user) do
    User.create!(email: "example@gmail.com", password: "password")
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it do
    should validate_length_of(:password).
      is_at_least(6).
      on(:create)
    end

  describe "#is_password?" do

    it "accepts a correct password" do
      expect(user.is_password?("password")).to be true
    end

    it "rejects an incorrect password" do
      expect(user.is_password?("not_password")).to be false
    end
  end

  describe "#reset_session_token" do

    it "creates a session token before validation" do
      expect(user.session_token).to_not be_nil
    end

    it "resets the session token" do
      expect(user.session_token).not_to eq(user.reset_session_token!)
    end

    it "returns the new session token" do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe "::find_by_credentials" do

    it "finds the correct user" do
      expect(User.find_by_credentials(user.email, "password")).to eq(user)
    end

    it "returns nil if given invalid credentials" do
      expect(User.find_by_credentials("nobody@gmail.com", "wrong_password")).not_to eq(user)
    end
  end
end
