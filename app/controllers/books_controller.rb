class BooksController < ApplicationController
  def create
    begin
      book = Book.create!(author: params[:author], title: params[:title])
      render json: book
    rescue ActiveRecord::RecordInvalid => e
      render json: {errors: e.message}, status: 400
    end
  end

  def index
  end
end
