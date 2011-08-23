#!/usr/bin/env ruby
# encoding: utf-8
#

puts 'Loading libs...'
require 'rubygems'
require 'icalendar'
require 'date'

def simple_date(date)
	return date.strftime('%A %d %B %Y %H:%M')
end

puts 'Parsing file...'
cal_file = File.open("KTH.test1.ical", :encoding => 'utf-8')

cals = Icalendar.parse(cal_file)

@mainCal = nil

# Look for the specific calendar we want.
# For now, we just take the first one (do these things have name, id, or whatever we could use to select ?)
@mainCal = cals.first

@evts = @mainCal.events

@evts.each { |evt| 
	puts evt.summary
	puts "From #{simple_date evt.dtstart} to #{simple_date evt.dtend}"
	puts "Location: #{evt.location}"
	puts "Description: #{evt.description}"
	puts ""
}
