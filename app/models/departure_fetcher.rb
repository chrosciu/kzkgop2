class DepartureFetcher

  attr_accessor :stop_id, :direction_ids, :scope_ids

  def initialize(options =  {})
    self.stop_id = options[:stop_id]
    self.direction_ids = options[:direction_ids]
    self.scope_ids = options[:scope_ids]
  end

  def to_s
    "#<DepartureFetcher stop_id: #{stop_id.inspect}, direction_ids: #{direction_ids.inspect}, scope_ids: #{scope_ids.inspect}>"
  end

  def uri
    URI.escape "http://rozklady.kzkgop.pl/index.php?id_przystanku=#{stop_id}&co=tabliczka_zbiorcza&#{directions_query}"
  end

  def directions_query
    direction_ids.map { |direction_id| "kierunki[]=#{direction_id}" }.join('&')
  end

  def fetch
    body = open(uri, 'Cookie' => 'typ_wyswietlania_rozkladu=pionowo;')
    doc = Nokogiri::HTML(body)
    binding.pry
    #doc.css('div#tabliczka_topinfo').first.css('a#nr_lini_rozklad').text
    #doc.css('div#tabliczka_topinfo').first.css('h3').text[10..-1]
    doc.css('table#tabliczka_pionowo').map {|direction_table| scoped_direction_departures(direction_table)}
  end

  def scoped_direction_departures(direction_table)
    rows = direction_table.css('td')
    departures = parse_rows(rows)
    departures = departures.group_by {|departure| departure.scope_id}
    departures.keys.each do |scope_id|
      departures[Scope.find(scope_id)] = departures[scope_id] if scope_ids.include? scope_id
      departures.delete(scope_id)
    end
    departures
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
            notice = col.css('span').text
            future = in_future?(hour, minute)
            course_href = col.attr('href')
            course_id = course_href.scan(/id_kursu=(\d+)\&/).flatten.first.to_i
            departures << Departure.new(hour: hour, minute: minute, scope_id: scope.id, notice: notice, future: future, course_id: course_id)
          end
        end
      end
    end
    departures
  end

  def in_future?(hour, minute)
    hour > current_hour || (hour == current_hour && minute >= current_minute)
  end

  def zone
    @zone ||= ActiveSupport::TimeZone['Warsaw']
  end

  def current_time
    zone.at(Time.now)
  end

  def current_hour
    current_time.hour
  end

  def current_minute
    current_time.min
  end

end
