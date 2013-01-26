require 'open-uri'

class Departure
  include ActiveAttr::Model

  attribute :hour, type: Integer
  attribute :minute, type: Integer
  attribute :scope_id, type: Integer

  class << self

    def fetch_all_scoped_departures(stop_id)
      directions = Direction.fetch_directions(stop_id)
      all_scoped_departures = {}
      directions.each do |direction|
        all_scoped_departures[direction] = fetch_scoped_departures(stop_id, direction.id)
      end
      all_scoped_departures
    end

    def fetch_scoped_departures(stop_id, direction_id)
      body = open(uri(stop_id, direction_id), 'Cookie' => 'typ_wyswietlania_rozkladu=pionowo;')
      doc = Nokogiri::HTML(body)
      rows = doc.css('table#tabliczka_pionowo').css('td')
      departures = parse_rows(rows)
      scoped(departures)
    end

    def parse_rows(rows)
      departures = []
      hour = nil
      rows.each do |row|
        if row.attr(:class).include? 'td_godziny'
          hour = row.text.to_i
        else
          if scope = Scope.find_by_html_class(row.attr(:class))
            row.css('a').each do |col|
              minute = col.text.to_i
              departures << new(hour: hour, minute: minute, scope_id: scope.id)
            end
          end
        end
      end
      departures
    end

    private

    def uri(stop_id, direction_id)
      URI.escape "http://rozklady.kzkgop.pl/index.php?id_przystanku=#{stop_id}&co=tabliczka_zbiorcza&kierunki[]=#{direction_id}"
    end

    def within_scope(departures, scope)
      departures.select {|d| d.scope_id == scope.id }
    end

    def scoped(departures)
      scoped = {}
      Scope.all.each do |scope|
        scoped[scope] = within_scope(departures, scope)
      end
      scoped
    end

  end

end
