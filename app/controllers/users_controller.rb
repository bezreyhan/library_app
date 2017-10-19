class UsersController < ApplicationController
  def create
    begin
      user = User.create!(username: params[:username])
      render json: user
    rescue ActiveRecord::RecordInvalid => e
      render json: {errors: e.message}, status: 400
    end
  end
end
