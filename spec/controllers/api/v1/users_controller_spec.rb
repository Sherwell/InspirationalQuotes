require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
	before(:each) { request.headers['Accept'] = "application/vnd.quotes.v1" }

	describe "GET #show" do
		let(:subject){ create :user }

		it "returns the information about a reporter on a hash" do
			get :show, id: subject.id, format: :json

			user_response = JSON.parse(response.body, symbolize_names: true)
			expect(user_response[:user][:email]).to eq(subject.email)

			#expect code 200 - status-code
			expect(response.status).to eq(200)
		end
	end
end
