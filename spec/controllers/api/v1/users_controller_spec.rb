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
			context "with valid attributes" do 
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

			context "with invalid attributes" do 
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

		describe "PUT/PATCH #update" do 
			context "with valid attributes" do 
				before(:each) do 
					patch :update, { id: subject.id, user: { email: "newmail@example.com" } }, format: :json
				end

				it "renders the json representation for the updated user" do 
					user_response = JSON.parse(response.body, symbolize_names: true)
					expect(user_response[:email]).to eql("newmail@example.com")
				end

				it "respons with status-code 200" do 
					expect(response.status).to eq(200)
				end
			end

			context "with invalid attributes" do 
				before(:each) do 
					patch :update, { id: subject.id, user: { email: "bademail.com" } }
				end

				it "renders an errors json" do 
					user_response = JSON.parse(response.body, symbolize_names: true)
					expect(user_response).to have_key(:errors)
				end

				it "renders the json errors on why the user could not be created" do 
					user_response = JSON.parse(response.body, symbolize_names: true)
					expect(user_response[:errors][:email]).to include "is invalid"
				end

				it "responds with status-code 422" do 
					expect(response.status).to eq(422)
				end
			end	
		end

		describe "DELETE #destroy" do 
			before(:each) do 
				delete :destroy, { id: subject.id }, format: :json 
			end

			it "responds with status-code 204" do 
				expect(response.status).to eq(204)
			end
		end
	end
end
