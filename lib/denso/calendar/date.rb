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

      # Returns true if the day is holiday
      #
      # @return [Boolean]
      # @see #business_day?
      def holiday?
        @holiday
      end

      # Returns true if the day is business day, meaning not holiday
      #
      # @return [Boolean]
      # @see #holiday?
      def business_day?
        !holiday?
      end
    end
  end
end