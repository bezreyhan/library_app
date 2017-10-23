class ApplicationController < ActionController::Base
  protect_from_forgery except: :create
  rescue_from StandardError do |e|
    render json: {error: "Internal Server Error"}, status: 500
  end
end
