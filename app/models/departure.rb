class Departure
  include ActiveAttr::Model

  attribute :hour, type: Integer
  attribute :minute, type: Integer
  attribute :scope_id, type: Integer
  attribute :notice, type: String
  attribute :future, type: Boolean
  attribute :course_id, type: Integer

end
