class UsersController < ApplicationController
  def new
    @cities = City.all
  end

  def create
    begin
      user = User.create!(
        email: params[:email],
        city: City.find(params[:city_id])
      )
    rescue => e
      user_message = "Oops, something when wrong."

      if e.message == "Validation failed: Email is invalid"
        user_message = "Please use a correctly formatted email!"
      elsif e.class == ActiveRecord::RecordNotUnique && e.message.include?("users_email_key")
        user_message = "'#{params[:email]}' already in use!"
      end

      redirect_to root_path, :flash => { :danger => user_message }
    end
  end
end
