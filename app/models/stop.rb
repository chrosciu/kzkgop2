require 'open-uri'

class Stop
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :name, type: String

  class << self

    def fetch_stops(query)
       stops = []
       body = open(uri(query))
       entries = body.string.force_encoding('UTF-8').split(/\n/).map {|s| s.split('|')}
       entries.each do |entry|
         stops << new(id: entry[1].to_i, name: entry[0])
       end
       stops
    end

    def uri(query)
      URI.escape "http://rozklady.kzkgop.pl/ajax/przystanki_quicksearch.php?q=#{query.try(:pl2en!)}"
    end

  end


end
