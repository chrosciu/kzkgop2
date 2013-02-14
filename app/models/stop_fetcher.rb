class StopFetcher

  include ActiveAttr::Model

  attribute :stop_id, type: Integer

  def stop
    @stop ||= fetch
  end

  def fetch
     body = open(uri)
     doc = Nokogiri::HTML(body)
     name = doc.css('div#info b').text.strip
     rows = doc.css('td')
     directions = parse_rows(rows)
     Stop.new(id: stop_id, name: name, directions: directions)
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
        directions << Direction.new(id: id, route: route, name: name)
      end
    end
    directions
  end

  def uri
    URI.escape "http://rozklady.kzkgop.pl/index.php?co=linie_przystanku&id_przystanku=#{stop_id}"
  end
end
