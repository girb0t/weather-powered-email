class UsersController < ApplicationController
  def new
    @cities = City.all.order(:name)
  end

  def create
    begin
      user = User.create!(
        email: params[:email],
        city: City.find(params[:city_id])
      )
      render status: :ok, json: {
        message: "'#{user.email}' successfully subscribed!"
      }
    rescue => e
      user_message = "Oops, something went wrong."
      status = 500

      if e.message == "Validation failed: Email is invalid"
        user_message = "Email formatted incorrectly."
        status = 400
      elsif e.class == ActiveRecord::RecordNotUnique && e.message.include?("users_email_key")
        user_message = "'#{params[:email]}' already in use!"
        status = 400
      end

      render status: status, json: {
        message: user_message
      }.to_json
    end
  end
end
