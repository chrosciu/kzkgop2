class DeparturesController < ApplicationController
  def index
    @all_scoped_departures = DepartureFetcher.new(params).fetch
  end
end
