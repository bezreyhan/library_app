class BookOwnershipsController < ApplicationController
  def create
    begin
      ownership = BookOwnership.create!(user_id: params[:user_id], book_id: params[:book_id], read: false)
      book = Book.find(params[:book_id])
      render json: ownership.with_book_attrs
    rescue ActiveRecord::RecordInvalid => e
      if e.message == "Validation failed: User already owns that book"
        render json: {errors: e.message}, status: 409
      else
        render json: {errors: e.message}, status: 404
      end
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
      head :no_content
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
      user = User.find(params[:user_id]) # check to see that the user exists
      query = params.permit(:user_id, :read)
      ownerships = if params[:author]
        then BookOwnership.where(query).joins(:book)
                          .where(books: { author: params[:author] })
        else BookOwnership.where(query)
      end
      render json: ownerships.with_book_attrs
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: 404
    end
  end
end