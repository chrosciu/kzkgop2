class DirectionsController < ApplicationController
  def index
    @stop_id = params[:stop_id]
    @directions = Direction.fetch_directions(@stop_id)
  end
end
