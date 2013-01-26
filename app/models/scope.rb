class Scope
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :name, type: String

  ALL = [
    new(id: 12, name: 'Robocze'),
    new(id: 13, name: 'Soboty'),
    new(id: 14, name: 'Niedziele i swieta'),
    new(id: 17, name: 'Robocze szkolne'),
    new(id: 18, name: 'Wolne'),
    new(id: 19, name: 'Robocze w ferie i wakacje')
  ]

  class << self

    def all
      ALL
    end

    def find_by_html_class(klass)
      ALL.select { |scope| klass.include? scope.html_class }.first
    end

  end

  def html_class
    "typ_dnia_#{id}"
  end

end
