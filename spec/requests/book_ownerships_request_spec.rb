require 'rails_helper'

RSpec.describe 'BookOwnerships Endpoints', type: :request do
  describe 'POST user_books' do
    context 'with valid user_id and book_id' do
      it 'returns http success' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')
        post user_books_url(user_id: user.id, book_id: book.id)
        expect(response).to have_http_status(:success)
      end

      it 'returns a book with a read property' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')

        post user_books_url(user_id: user.id, book_id: book.id)
        parsed = JSON.parse(response.body)

        expect(parsed['title']).to eql(book.title)
        expect(parsed['author']).to eql(book.author)
        expect(parsed['read']).to eql(false)
      end
    end

    context 'with an incorrect user_id' do
      it 'return a status 404' do
        book = Book.create!(author: 'test_author', title: 'test_title')

        post user_books_url(user_id: 'fake_fake', book_id: book.id)
        expect(response).to have_http_status(404)
      end
    end

    context 'with an incorrect book_id' do
      it 'return a status 404' do
        user = User.create!(username: 'test_user')

        post user_books_url(user_id: user.id, book_id: 'fake_fake')
        expect(response).to have_http_status(404)
      end
    end

    context 'without a book_id' do
      it 'return a status 404' do
        user = User.create!(username: 'test_user')

        post user_books_url(user_id: user.id)
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user already has that book' do
      it 'return a status 409' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')
        BookOwnership.create!(user: user, book: book, read: false)
        post user_books_url(user_id: user.id, book_id: book.id)
        expect(response).to have_http_status(409)
      end
    end
  end

  describe 'PUT user_book' do
    context 'with read = true' do
      before do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        ownership = BookOwnership.create(user_id: user.id, book_id: book.id, read: false)
        put user_book_url(user_id: user.id, id: book.id, read: true)
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
        put user_book_url(user_id: user.id, id: book.id, read: false)
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
        put user_book_url(user_id: user.id, id: book.id)
      end

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'with an invalid user_id' do
      before do
        book = Book.create(author: 'test_author', title: 'test_title')
        put user_book_url(user_id: 'fake_fake', id: book.id, read: true)
      end

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user does not own the book' do
      before do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        put user_book_url(user_id: user.id, id: book.id, read: true)
      end

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE user_book' do
    context 'for a valid user and book' do
      before do
        @user = User.create!(username: 'test_user')
        @book = Book.create!(author: 'test_author', title: 'test_title')
        BookOwnership.create!(user: @user, book: @book, read: false)
      end

      it 'return a status 204' do
        delete user_book_url(user_id: @user.id, id: @book.id)
        expect(response).to have_http_status(204)
      end

      it 'deletes the book from the users library' do
        delete user_book_url(user_id: @user.id, id: @book.id)
        expect{@user.books.find(@book.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the user does not exist' do
      it 'return a status 404' do
        book = Book.create(author: 'test_author', title: 'test_title')
        delete user_book_url(user_id: 'fake_fake', id: book.id)
        expect(response).to have_http_status(404)
      end
    end

    context 'when the user does not own the book' do
      it 'return a status 404' do
        user = User.create(username: 'test_user')
        book = Book.create(author: 'test_author', title: 'test_title')
        delete user_book_url(user_id: user.id, id: book.id)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET user_books' do
    context 'when the user is valid' do
      it 'returns a status 200' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')
        BookOwnership.create!(user: user, book: book, read: false)
        get user_books_url(user_id: user.id)
        expect(response).to have_http_status(200)
      end

      it 'returns a list of all book the user owns' do
        user = User.create!(username: 'test_user')
        book = Book.create!(author: 'test_author', title: 'test_title')
        ownership = BookOwnership.create!(user: user, book: book, read: false)
        get user_books_url(user_id: user.id)
        response_len = JSON.parse(response.body).length
        expect(response_len).to eql(user.books.count)
      end
    end

    context 'that have been read' do
      it 'returns a list of the users books that have been read' do
        user = User.create!(username: 'user1')
        book1 = Book.create!(author: 'author1', title: 'title1')
        book2 = Book.create!(author: 'author2', title: 'title2')
        ownership1 = BookOwnership.create!(user: user, book: book1, read: false)
        ownership2 = BookOwnership.create!(user: user, book: book2, read: true)
        get user_books_url(user_id: user.id, read: true)
        response_len = JSON.parse(response.body).length
        expect(response_len).to eql(1)
      end
    end

    context 'that have not been read' do
      it 'returns a list of the users books that have been read' do
        user = User.create!(username: 'user1')
        book1 = Book.create!(author: 'author1', title: 'title1')
        book2 = Book.create!(author: 'author2', title: 'title2')
        ownership1 = BookOwnership.create!(user: user, book: book1, read: false)
        ownership2 = BookOwnership.create!(user: user, book: book2, read: true)
        get user_books_url(user_id: user.id, read: false)
        response_len = JSON.parse(response.body).length
        expect(response_len).to eql(1)
      end
    end

    context 'when the user is invalid' do
      it 'returns a status 404' do
        get user_books_url(user_id: 'fake_fake')
        expect(response).to have_http_status(404)
      end
    end
  end
end
