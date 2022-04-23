#!/usr/bin/env ruby

require "json"
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

json = File.read("stoppoints.json")

data = JSON.parse(json)

stops = data.fetch("stopPoints")
  .map { |hash| BusStop.new(hash) }
  .sort {|a,b| a.distance <=> b.distance}

debugger

pp data
