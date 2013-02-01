require 'open-uri'

class CourseStop
  include ActiveAttr::Model

  attribute :name, type: String
  attribute :time, type: String
end
