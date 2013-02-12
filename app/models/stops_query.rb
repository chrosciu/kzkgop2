require 'open-uri'

class StopsQuery
  include ActiveAttr::Model

  attribute :query, type: String

  def stops
    @stops ||= fetch_stops
  end

  def fetch_stops
     stops = []
     body = open(uri)
     entries = body.string.force_encoding('UTF-8').split(/\n/).map {|s| s.split('|')}
     entries.each do |entry|
       stops << new(id: entry[1].to_i, name: entry[0])
     end
     stops
  end

  def uri
    URI.escape "http://rozklady.kzkgop.pl/ajax/przystanki_quicksearch.php?q=#{query.try(:pl2en!)}"
  end

end
