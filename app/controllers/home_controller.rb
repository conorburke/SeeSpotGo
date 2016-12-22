class HomeController < ApplicationController
  def index
    @locations = current_user ? current_user.locations : []
    @location = Location.new
    @space = Space.new
  end
end
