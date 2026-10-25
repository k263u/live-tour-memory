class HomeController < ApplicationController
  def top
    redirect_to trips_path if logged_in?
  end
end
