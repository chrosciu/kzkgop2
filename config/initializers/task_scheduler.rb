require 'rufus/scheduler'

unless Rails.env.development?

  scheduler = Rufus::Scheduler.start_new

  scheduler.every '10m' do
     require 'net/http'
     require 'uri'
     url = 'http://kzkgop.herokuapp.com/stops'
     Net::HTTP.get_response(URI.parse(url))
  end

end
