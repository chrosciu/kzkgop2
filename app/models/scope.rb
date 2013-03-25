class Scope
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :name, type: String

  ALL = [
    new(id: 12, name: 'Robocze'),
    new(id: 13, name: 'Soboty'),
    new(id: 14, name: 'Niedziele i swieta'),
    new(id: 15, name: 'Wigilia'),
    new(id: 16, name: 'Sylwester'),
    new(id: 17, name: 'Robocze szkolne'),
    new(id: 18, name: 'Wolne'),
    new(id: 19, name: 'Robocze w ferie i wakacje'),
    new(id: 20, name: 'Dni wolne od pracy w CH'),
    new(id: 21, name: 'Robocze szkolne i w ferie'),
    new(id: 22, name: 'Robocze w wakacje'),
    new(id: 23, name: 'Wszystkich Swietych'),
    new(id: 38, name: 'Codziennie'),
    new(id: 41, name: 'Dni wolne poza wolnymi od pracy w CH')
  ]

  class << self

    def all
      ALL
    end

    def find_by_html_class(klass)
      ALL.select { |scope| klass.include? scope.html_class }.first
    end

    def find(id)
      ALL.select { |scope| scope.id == id }.first
    end

  end

  def html_class
    "typ_dnia_#{id}"
  end

end
