require 'spec_helper'

RSpec.describe User, type: :model do
  let(:subject) { create :user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when email is not present" do
  	it "should not be valid" do
	  	subject.email = ""

	  	expect(subject.valid?).to be_falsey
	end
  end
end
