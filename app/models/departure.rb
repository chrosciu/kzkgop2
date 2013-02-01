require 'open-uri'

class Departure
  include ActiveAttr::Model

  attribute :hour, type: Integer
  attribute :minute, type: Integer
  attribute :scope_id, type: Integer
  attribute :notice, type: String
  attribute :future, type: Boolean

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

    private

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
              notice = col.css('span').text
              future = in_future?(hour, minute)
              departures << new(hour: hour, minute: minute, scope_id: scope.id, notice: notice, future: future)
            end
          end
        end
      end
      departures
    end

    def in_future?(hour, minute)
      hour > current_hour || (hour == current_hour && minute >= current_minute)
    end

    def current_time
      Time.now
    end

    def current_hour
      current_time.hour
    end

    def current_minute
      current_time.min
    end

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
