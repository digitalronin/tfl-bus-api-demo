#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri"
require "sinatra"

require "debug"

class BusStop
  attr_reader :id, :name, :lat, :lon, :distance

  def initialize(hash)
    @id = hash.fetch("naptanId")
    @lat = hash.fetch("lat")
    @lon = hash.fetch("lon")
    @distance = hash.fetch("distance")
    @name = [
      hash.fetch("commonName"),
      hash.fetch("indicator"),
    ].join(" ")
  end
end

class Location
  attr_reader :lat, :lon

  def initialize(hash)
    @lat = hash.fetch(:lat)
    @lon = hash.fetch(:lon)
  end

  def nearest_bus_stops
    Api.stop_points(lat: lat, lon: lon)
      .map { |hash| BusStop.new(hash) }
      .sort {|a,b| a.distance <=> b.distance}
  end
end

class Api
  def self.stop_points(lat:, lon:)
    url = "https://api.tfl.gov.uk/StopPoint/?lat=#{lat}&lon=#{lon}&stopTypes=NaptanPublicBusCoachTram&radius=250&modes=bus"
    json = Net::HTTP.get(URI(url))
    data = JSON.parse(json)
    data.fetch("stopPoints")
  end
end

# lat = 51.5000182
# lon = -0.1347679
#
# location = Location.new({lat: lat, lon: lon})
#
# stops = location.nearest_bus_stops

set :bind, '0.0.0.0'

get "/" do
  "Hello, World!"
end
