# frozen_string_literal: true

module Denso
  class Calendar
    module Formatter
      class Ical
        def format(calendar)
          require 'icalendar'

          cal = Icalendar::Calendar.new
          calendar.holidays.each do |holiday|
            cal.event do |e|
              e.dtstart = Icalendar::Values::Date.new(holiday)
              e.dtend = Icalendar::Values::Date.new(holiday)
            end
          end
          cal.publish

          cal.to_ical
        end
      end
    end
  end
end