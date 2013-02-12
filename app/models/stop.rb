class Stop

  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :name, type: String

  attr_accessor :directions

end
