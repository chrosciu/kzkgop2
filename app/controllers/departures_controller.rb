class DeparturesController < ApplicationController
  def index
    if params[:direction_ids].present?
      @all_scoped_departures = Departure.fetch_selected_scoped_departures(params[:stop_id], params[:direction_ids])
    else
      @all_scoped_departures = Departure.fetch_all_scoped_departures(params[:stop_id])
    end
  end
end
