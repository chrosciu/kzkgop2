class StopsController < ApplicationController
  def index
    @stops = Stop.fetch_stops(params[:query])
  end
end
