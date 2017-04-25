class UsersController < ApplicationController
  def new
    @cities = City.all
  end

  def create
    binding.pry
  end
end
