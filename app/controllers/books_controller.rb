class BooksController < ApplicationController
  def create
    begin
      book = Book.create!(author: params[:author], title: params[:title])
      render json: book
    rescue ActiveRecord::RecordInvalid => e
      if e.message == 'Validation failed: Title with that author already exists'
        render json: {errors: e.message}, status: 409
      else
        render json: {errors: e.message}, status: 404
      end
    end
  end
end
