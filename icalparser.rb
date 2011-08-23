#!/usr/bin/env ruby
# encoding: UTF-8

puts 'Loading libs...'
require 'rubygems'
require 'icalendar'
require 'date'
require 'net/http'
require 'net/https'
require_relative 'config.rb'

def simple_date(date)
	return date.strftime('%A %d %B %Y %H:%M')
end
def canonicalDate(date)
	return date.strftime('%Y%B%d')
end

class Course
	attr_accessor :start, :end, :summary, :description, :location
	def initialize(starttime, endtime, summary, description, location)
		@start = starttime
		@end = endtime
		@summary = summary
		@description = description
		@location = location
	end
end

# Updates the courses hash
def updateCourses
	puts 'Fetching file...'
	uri = URI.parse(@ical_url)
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	res = http.request_get(uri.request_uri)

	parseFile res.body
end

def parseFile(cal_string)
	puts 'Parsing file...'

	cals = Icalendar.parse(cal_string)

	# Look for the specific calendar we want.
	# For now, we just take the first one (do these things have name, id, or whatever we could use to select ?)
	mainCal = cals.first

	evts = mainCal.events

	@courses = Hash.new

	evts.each { |evt| 
		key = canonicalDate evt.dtstart
		course = Course.new(evt.dtstart, evt.dtend, evt.summary, evt.description, evt.location)
		if @courses[key] == nil then
			@courses[key] = [course]
		else
			@courses[key][@courses[key].length] = course
		end

	}

end

updateCourses

@courses.each { |day,evts|
	puts "Day: #{day}"
	evts.each { |evt|
		puts evt.summary
		puts "From #{simple_date evt.start} to #{simple_date evt.end}"
		puts "Location: #{evt.location}"
		puts "Description: #{evt.description}"
		puts ""
	}
}

