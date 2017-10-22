require 'rails_helper'

RSpec.describe "Books Endpoints", type: :request do

  describe "POST books" do
    context "with a valid author and title" do
      let(:create_book) { post books_url(author: 'test_author', title: 'test_title') }

      it "returns http success" do
        create_book
        expect(response).to have_http_status(:success)
      end

      it 'created a new user' do
        prev_count = Book.count
        create_book
        expect(prev_count + 1).to eql(Book.count)
      end

      it "returns the created user in json format" do
        create_book
        expect(response.body).to eql(Book.last.to_json)
      end
    end

    context "when the book already exists" do
      it "return a status 409" do
        Book.create!(author: 'test_author', title: 'test_title')
        post books_url(author: 'test_author', title: 'test_title')
        expect(response).to have_http_status(409)
      end
    end

    context "without a title" do
      it "return a status 404" do
        post books_url(author: 'test_author')
        expect(response).to have_http_status(404)
      end
    end

    context "without a author" do
      it "return a status 404" do
        post books_url(title: 'test_title')
        expect(response).to have_http_status(404)
      end
    end
  end
end
