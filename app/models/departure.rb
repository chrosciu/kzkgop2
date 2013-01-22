require 'open-uri'

class Departure
  include ActiveAttr::Model

  attribute :hour, type: Integer
  attribute :minute, type: Integer
  attribute :scope, type: Integer

  class << self

    def fetch_departures(stop_id, direction_id)
      body = open(uri(stop_id, direction_id), 'Cookie' => 'typ_wyswietlania_rozkladu=pionowo;')
      doc = Nokogiri::HTML(body)
      rows = doc.css('table#tabliczka_pionowo').css('td')
      parse_rows(rows)
    end

    def parse_rows(rows)
      departures = []
      hour = nil
      rows.each do |row|
        if row.attr(:class).include? 'td_godziny'
          hour = row.text.to_i
        elsif row.attr(:class).include? 'typ_dnia_12'
          row.css('a').each do |col|
            minute = col.text.to_i
            departures << new(hour: hour, minute: minute, scope: 12)
          end
        elsif row.attr(:class).include? 'typ_dnia_13'
          row.css('a').each do |col|
            minute = col.text.to_i
            departures << new(hour: hour, minute: minute, scope: 13)
          end
        elsif row.attr(:class).include? 'typ_dnia_14'
          row.css('a').each do |col|
            minute = col.text.to_i
            departures << new(hour: hour, minute: minute, scope: 14)
          end
        elsif row.attr(:class).include? 'typ_dnia_18'
          row.css('a').each do |col|
            minute = col.text.to_i
            departures << new(hour: hour, minute: minute, scope: 18)
          end
        end
      end
      departures
    end

    def uri(stop_id, direction_id)
      "http://rozklady.kzkgop.pl/index.php?id_przystanku=#{stop_id}&co=tabliczka_zbiorcza&kierunki[]=#{direction_id}"
    end

    def within_scope(departures, scope)
      departures.select {|d| d.scope == scope }
    end

  end

end
