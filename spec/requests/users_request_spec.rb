require 'rails_helper'

RSpec.describe UsersController, type: :request do

  describe "Post users" do
    context "with a valid username" do
      let(:create_user) { post users_url(username: 'test_user') }

      it "returns http success" do
        create_user
        expect(response).to have_http_status(:success)
      end

      it 'created a new user' do
        prev_count = User.count
        create_user
        expect(prev_count + 1).to eql(User.count)
      end

      it "returns the created user in json format" do
        create_user
        expect(response.body).to eql(User.last.to_json)
      end
    end

    context "with a pre-existing username" do
      it "return a status 400" do
        username = 'test_user'
        User.create(username: username)
        post users_url(username: username)
        expect(response).to have_http_status(400)
      end
    end

    context "without an username" do
      it "return a status 400" do
        post users_url
        expect(response).to have_http_status(400)
      end
    end
  end
end
