class Directions::DeparturesController < ApplicationController
  def index
    @scoped_departures = Departure.fetch_scoped_departures(params[:stop_id], params[:direction_id])
  end
end
