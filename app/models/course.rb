require 'open-uri'

class Course
  include ActiveAttr::Model

  attribute :id, type: Integer

  attr_accessor :stops

  class << self

    def fetch(course_id)
      body = open(uri(course_id))
      doc = Nokogiri::HTML(body)
      rows = doc.css('tr.tr_aktywny')
      course_stops = parse_rows(rows)
      new(id: course_id, stops: course_stops)
    end

    def parse_rows(rows)
      course_stops = []
      rows.each do |row|
        stop_href = row.css('a').first.attr('href')
        stop_id = stop_href.scan(/id_przystanku=(\d+)\z/).flatten.first.to_i
        name = row.css('td')[1].text
        time = row.css('td')[2].text
        course_stops << CourseStop.new(stop_id: stop_id, name: name, time: time)
      end
      course_stops
    end

    def uri(course_id)
      "http://rozklady.kzkgop.pl/rozklad/pokaz_kurs.php?id_kursu=#{course_id}"
    end

  end

end
