# frozen_string_literal: true

require 'date'

module Denso
  class Calendar
    class Date < ::Date
      def initialize(*args, holiday: true)
        super(*args)

        @holiday = holiday
      end

      def holiday?
        @holiday
      end

      def business_day?
        !holiday?
      end
    end
  end
end