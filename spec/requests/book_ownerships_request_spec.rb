require 'rails_helper'

RSpec.describe 'BookOwnerships Endpoints', type: :request do
  describe 'POST users_book_ownership' do
    context 'with valid user_id and book_id' do
      it 'returns http success' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')
        post user_book_ownerships_url(user_id: user.id, book_id: book.id)
        expect(response).to have_http_status(:success)
      end

      it 'returns a book with a read property' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')

        post user_book_ownerships_url(user_id: user.id, book_id: book.id)
        parsed = JSON.parse(response.body)

        expect(parsed['title']).to eql(book.title)
        expect(parsed['author']).to eql(book.author)
        expect(parsed['read']).to eql(false)
      end
    end

    context 'with an incorrect user_id' do
      it 'return a status 404' do
        book = Book.create!(author: 'test_author', title: 'test_title')

        post user_book_ownerships_url(user_id: 'fake_fake', book_id: book.id)
        expect(response).to have_http_status(404)
      end
    end

    context 'with an incorrect book_id' do
      it 'return a status 404' do
        user = User.create!(username: 'test_user')

        post user_book_ownerships_url(user_id: user.id, book_id: 'fake_fake')
        expect(response).to have_http_status(404)
      end
    end

    context 'without a book_id' do
      it 'return a status 404' do
        user = User.create!(username: 'test_user')

        post user_book_ownerships_url(user_id: user.id)
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user already has that book' do
      it 'return a status 409' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')
        BookOwnership.create!(user: user, book: book, read: false)
        post user_book_ownerships_url(user_id: user.id, book_id: book.id)
        puts response.body
        expect(response).to have_http_status(409)
      end
    end
  end

  describe 'PUT user_book_ownership' do
    context 'with read = true' do
      before do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        ownership = BookOwnership.create(user_id: user.id, book_id: book.id, read: false)
        put user_book_ownership_url(user_id: user.id, book_id: book.id, read: true)
      end

      it 'returns http success' do
        expect(response).to have_http_status(200)
      end

      it 'return the ownership object with read = true' do
        expect(JSON.parse(response.body)['read']).to eql(true)
      end
    end

    context 'with read = false' do
      before do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        ownership = BookOwnership.create(user_id: user.id, book_id: book.id, read: true)
        put user_book_ownership_url(user_id: user.id, book_id: book.id, read: false)
      end

      it 'returns http success' do
        expect(response).to have_http_status(200)
      end

      it 'return the ownership object with read = true' do
        expect(JSON.parse(response.body)['read']).to eql(false)
      end
    end

    context 'with read = nil' do
      before do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        ownership = BookOwnership.create(user_id: user.id, book_id: book.id, read: false)
        put user_book_ownership_url(user_id: user.id, book_id: book.id)
      end

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'with an invalud user_id' do
      before do
        book = Book.create(author: 'test_author', title: 'test_title')
        put user_book_ownership_url(user_id: 'fake_fake', book_id: book.id, read: true)
      end

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user does not own the book' do
      before do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        put user_book_ownership_url(user_id: user.id, book_id: book.id, read: true)
      end

      it 'returns status 404' do
        puts "_+_+_+_+_+_+_+_+_+"
        puts response.body
        expect(response).to have_http_status(404)
      end
    end
  end
end
