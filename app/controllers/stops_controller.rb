class StopsController < ApplicationController

  def index
    @stops = params[:query].present? ? StopsSearch.new(query: params[:query]).stops : []
  end

  def show
    @stop = StopFetcher.new(stop_id: params[:id]).stop
  end

end
