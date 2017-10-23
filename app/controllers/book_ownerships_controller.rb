class BookOwnershipsController < ApplicationController
  def create
    begin
      user = User.find(params[:user_id])
      book = Book.find(params[:book_id])
      ownership = BookOwnership.create!(user: user, book: book, read: false)
      book = Book.find(params[:book_id])
      render json: ownership.with_book_attrs
    rescue ActiveRecord::RecordInvalid => e
      if e.message == "Validation failed: User already owns that book"
        render json: {errors: e.message}, status: 409
      else
        render json: {errors: e.message}, status: 404
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: 404
    end
  end

  def update
    begin
      params.require(:read)
      user = User.find(params[:user_id])
      book = Book.find(params[:id])
      ownership = BookOwnership.find_by!(user: user, book: book)
      ownership.update!(read: params[:read])
      render json: ownership.with_book_attrs
    rescue ActiveRecord::RecordNotFound => e
      if e.message == "Couldn't find BookOwnership"
        render json: {errors: "User does not own that book"}, status: 404
      else
        render json: {errors: e.message}, status: 404
      end
    rescue ActionController::ParameterMissing => e
      render json: {errors: e.message}, status: 404
    end
  end

  def destroy
    begin
      user = User.find(params[:user_id])
      book = Book.find(params[:id])
      ownership = BookOwnership.find_by!(user: user, book: book)
      ownership.destroy!
      render json: {message: 'Removed'}, status: 200
    rescue ActiveRecord::RecordNotFound => e
      if e.message == "Couldn't find BookOwnership"
        render json: {errors: "User does not own that book"}, status: 404
      else
        render json: {errors: e.message}, status: 404
      end
    end
  end

  def index
    begin
      user = User.find(params[:user_id])
      query = params.permit!.to_hash.select {|k, v| ["read", "user_id"].include?(k) }
      ownerships = if params[:author] then
        BookOwnership.where(query).joins(:book).where(books: { author: params[:author] })
      else
        BookOwnership.where(query)
      end
      render json: ownerships.with_book_attrs
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: 404
    end
  end
end