class DeparturesController < ApplicationController
  def index
    stop_id = params[:stop_id]
    directions = Direction.fetch_directions(stop_id)
    @all = []
    directions.each do |direction|
      departures = Departure.fetch_departures(params[:stop_id], direction.id)
      working = Departure.within_scope(departures, 12)
      saturday = Departure.within_scope(departures, 13)
      sunday = Departure.within_scope(departures, 14)
      free = Departure.within_scope(departures, 18)
      single = {
        route: direction.route,
        name: direction.name,
        working: working,
        saturday: saturday,
        sunday: sunday,
        free: free
      }
      @all << single
    end
  end
end
