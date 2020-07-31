# frozen_string_literal: true

require 'date'

module Denso
  class Calendar
    class Date < ::Date
      def initialize(*args)
        options = args.last.is_a?(Hash) ? args.pop : { holiday: true }
        super(*args)

        @holiday = options[:holiday]
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