require 'open-uri'

class CourseStop
  include ActiveAttr::Model

  attribute :stop_id, type: Integer
  attribute :name, type: String
  attribute :time, type: String
end
