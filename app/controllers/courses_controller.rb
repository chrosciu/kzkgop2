class CoursesController < ApplicationController
  def show
    @course = Course.fetch(params[:id])
  end
end
