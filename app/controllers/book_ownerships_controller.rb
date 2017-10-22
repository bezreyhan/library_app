class BookOwnershipsController < ApplicationController
  def create
    begin
      ownership = BookOwnership.create!(user_id: params[:user_id], book_id: params[:book_id], read: false)
      book = Book.find(params[:book_id])
      render json: ownership.self_and_book_attrs
    rescue ActiveRecord::RecordInvalid => e
      render json: {errors: e.message}, status: 404
    end
  end

  def update
    begin
      params.require(:read)
      user = User.find(params[:user_id])
      book = Book.find(params[:book_id])
      ownership = BookOwnership.find_by!(user: user, book: book)
      ownership.update!(read: params[:read])
      render json: ownership.self_and_book_attrs
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: 404
    rescue ActionController::ParameterMissing => e
      render json: {errors: e.message}, status: 404
    end
  end
end
