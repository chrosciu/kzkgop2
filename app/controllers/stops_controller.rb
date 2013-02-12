class StopsController < ApplicationController

  def index
    @stops = StopsSearch.new(query: params[:query]).stops
  end

  def show
    @stop = StopFetcher.new(stop_id: params[:id]).stop
  end

end
