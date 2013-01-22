class Directions::DeparturesController < ApplicationController
  def index
    @departures = Departure.fetch_departures(params[:stop_id], params[:direction_id])
    @working = Departure.within_scope(@departures, 12)
    @saturday = Departure.within_scope(@departures, 13)
    @sunday = Departure.within_scope(@departures, 14)
    @school = Departure.within_scope(@departures, 17)
    @free = Departure.within_scope(@departures, 18)
    @holiday = Departure.within_scope(@departures, 19)
  end
end
