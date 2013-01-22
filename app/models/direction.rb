require 'open-uri'

class Direction
  include ActiveAttr::Model

  attribute :id, type: Integer
  attribute :route, type: String
  attribute :name, type: String

  class << self

    def fetch_directions(stop_id)
       body = open(uri(stop_id))
       doc = Nokogiri::HTML(body)
       rows = doc.css('td')
       parse_rows(rows)
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

    def uri(stop_id)
      "http://rozklady.kzkgop.pl/index.php?co=linie_przystanku&id_przystanku=#{stop_id}"
    end

  end


end
