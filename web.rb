#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri"
require "time"
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
    @lat = hash.fetch("lat")
    @lon = hash.fetch("lon")
  end

  def nearest_bus_stops
    Api.stop_points(lat: lat, lon: lon)
      .map { |hash| BusStop.new(hash) }
      .sort {|a,b| a.distance <=> b.distance}
  end
end

class Arrival
  attr_reader :line, :destination, :expected_arrival

  def initialize(hash)
    @line = hash.fetch("lineName")
    @destination = hash.fetch("destinationName")
    @expected_arrival = hash.fetch("expectedArrival")
  end

  def minutes_from_now
    seconds = Time.parse(expected_arrival) - Time.now
    seconds % 60
  end
end

class Api
  BASE_URL = "https://api.tfl.gov.uk"

  def self.stop_points(lat:, lon:)
    get_data("#{BASE_URL}/StopPoint/?lat=#{lat}&lon=#{lon}&stopTypes=NaptanPublicBusCoachTram&radius=250&modes=bus")
      .fetch("stopPoints")
  end

  def self.arrivals(stop_point_id)
    get_data("#{BASE_URL}/StopPoint/#{stop_point_id}/Arrivals")
  end

  def self.get_data(url)
    json = Net::HTTP.get(URI(url))
    JSON.parse(json)
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
  erb :index
end

get "/nearest_bus_stops" do
  location = Location.new(params)
  stops = location.nearest_bus_stops

  erb :nearest_bus_stops, locals: { stops: stops }
end

get "/arrivals/:stop_point_id" do
  arrivals = Api.arrivals(params["stop_point_id"])
    .map {|hash| Arrival.new(hash)}
    .sort {|a, b| a.minutes_from_now <=> b.minutes_from_now}

  erb :arrivals, locals: { arrivals: arrivals, name: params["name"] }
end
