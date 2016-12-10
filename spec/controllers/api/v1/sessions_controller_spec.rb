require 'spec_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
	describe "POST #create" do 
		context "with valid credentials" do 
			let(:subject){ create :user }
			before(:each) do 
				credentials = { email: subject.email, password: "12345678" }
				post :create, { session: credentials }
			end

			it "returns the user record corresponding to the given credentials" do 
				subject.reload
				expect(json_response[:auth_token]).to eql(subject.auth_token)
			end

			it "returns status code 200" do 
				expect(response.status).to eq(200)
			end
		end

		context "with invalid credentials" do 
			let(:subject){ create :user }
			before(:each) do 
				credentials = { email: subject.email, password: "invalidpassword" }
				post :create, { session: credentials }
			end

			it "returns a json with an error" do 
				expect(json_response[:errors]).to eql("Invalid email or password")
			end

			it "returns status code 422" do 
				expect(response.status).to eq(422)
			end
		end
	end

	describe "DELETE #destroy" do
		before(:each) do 
			user = create :user
			sign_in user
			delete :destroy, id: user.auth_token
		end
		
		it "should repsond with status code 204" do 
			expect(response.status).to eq(204)
		end
	end
end
