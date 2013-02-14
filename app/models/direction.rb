class Direction

  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :route, type: String
  attribute :name, type: String

end
