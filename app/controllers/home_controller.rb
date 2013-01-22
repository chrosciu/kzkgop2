class HomeController < ApplicationController
  def index
    redirect_to stop_directions_path(stop_id: 127)
  end
end
