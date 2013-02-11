require 'open-uri'

class Stop
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :name, type: String

  attr_accessor :directions

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

    def fetch(stop_id)
       body = open(uri2(stop_id))
       doc = Nokogiri::HTML(body)
       rows = doc.css('td')
       directions = parse_rows(rows)
       new(id: stop_id, name: 'X', directions: directions)
    end

    def parse_rows(rows)
      directions = []
      route = nil
      rows.each do |row|
        if row.attr(:class) == 'lp_td_nr_linii'
          route = row.css('a').text
        else
          id = row.css('input').first.attr(:value).to_i
          name = row.css('a').text
          directions << new(id: id, route: route, name: name)
        end
      end
      directions
    end

    def uri2(stop_id)
      URI.escape "http://rozklady.kzkgop.pl/index.php?co=linie_przystanku&id_przystanku=#{stop_id}"
    end


  end


end
