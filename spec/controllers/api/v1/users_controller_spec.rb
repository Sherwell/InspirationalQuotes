require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
	before(:each) { request.headers['Accept'] = "application/vnd.quotes.v1" }
	let(:subject){ create :user }

	describe "actions" do
		describe "GET #show" do
			it "returns the information about a reporter on a hash" do
				get :show, id: subject.id, format: :json

				user_response = JSON.parse(response.body, symbolize_names: true)
				expect(user_response[:user][:email]).to eq(subject.email)

				#expect code 200 - status-code
				expect(response.status).to eq(200)
			end
		end

		describe "POST #create" do 
			context "when is successfully created" do 
				before(:each) do 
					@user_attributes = attributes_for(:user)
					post :create, user: @user_attributes, format: :json
				end
				
				it "renders the json representation for the user record just created" do 
					user_response = JSON.parse(response.body, symbolize_names: true)
					expect(user_response[:email]).to eql(@user_attributes[:email])
				end

				it "should respond with 201" do 
					# test for 201 - status-code
					expect(response.status).to eq(201)
				end
			end

			context "when is not created" do 
				before(:each) do 
					#Not including email
					@invalid_user_attributes = { password: "12345678", password_confirmation: "12345678"}
					post :create, { user: @invalid_user_attributes }, format: :json
				end

				it "renders an error json" do 
					user_response = JSON.parse(response.body, symbolize_names: true)
					expect(user_response).to have_key(:errors)
				end

				it "renders the json errors on why teh user could not be created" do
					user_response = JSON.parse(response.body, symbolize_names: true)
					expect(user_response[:errors][:email]).to include "can't be blank"
				end

				it "should respond with 422" do 
					# test for 422 - status-code
					expect(response.status).to eq(422)
				end
			end
		end
	end
end
