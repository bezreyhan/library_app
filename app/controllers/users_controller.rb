class UsersController < ApplicationController
  def create
    begin
      user = User.create!(username: params[:username])
      render json: user
    rescue ActiveRecord::RecordInvalid => e
      if e.message == "Validation failed: Username has already been taken"
        render json: {errors: e.message}, status: 409
      else
        render json: {errors: e.message}, status: 404
      end
    end
  end
end
