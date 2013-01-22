class DirectionsController < ApplicationController
  def index
    @directions = Direction.fetch_directions(params[:stop_id])
  end
end
