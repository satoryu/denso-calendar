# frozen_string_literal: true

module Denso
  class Calendar
    module Formatter
      class Plain
        def format(calendar)
          out = StringIO.new
          calendar.holidays.each do |holiday|
            out.puts holiday
          end
        end
      end
    end
  end
end