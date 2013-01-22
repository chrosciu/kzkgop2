class HomeController < ApplicationController
  def index
    redirect_to stops_path
  end
end
