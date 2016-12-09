require 'spec_helper'

RSpec.describe User, type: :model do
  let(:subject) { create :user }

  it { should respond_to(:auth_token) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  describe "when email is not present" do
  	it "should not be valid" do
	  	subject.email = ""

	  	expect(subject).to_not be_valid
	  end
  end

  describe "when email is already used" do 
    let(:u1) { create :user, email: 'example@domain.com' }
    let(:u2) { build :user, email: 'example@domain.com' }
    
    it "should not be valid" do 
      u1.save
      expect(u2.valid?).to be_falsey
    end
  end

  describe "when auth_token is already used" do 
    let(:u1) { create :user }
    let(:u2) { build :user }
    
    it "should not be valid" do 
      u1.auth_token = "t123"
      u1.save
      u2.auth_token = "t123"
      expect(u2.valid?).to be_falsey
    end
  end

  describe "#generate_authentication_token!" do 
    it "generates a unique token" do 
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      user = create :user
      expect(user.auth_token).to eql("auniquetoken123")
    end

    it "generates another token when one already has been taken" do 
      existing_user = create :user, auth_token: "auniquetoken123"
      user = create :user
      expect(user.auth_token).not_to eql(existing_user.auth_token)
    end
  end
end
