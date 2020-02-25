# frozen_string_literal: true

require 'denso/calendar'
require 'denso/calendar/formatter'

module Denso
  class Calendar
    class Cli
      def self.run(options)
        new(options).run
      end

      attr_reader :options

      def initialize(argv)
        require 'optparse'
        opt = OptionParser.new
        opt.on('-t TYPE', '--type TYPE') { |v| v }

        @options = {}
        opt.parse(argv, into: @options)
      end

      def run
        calendar = Denso::Calendar.load(options[:type].to_sym)

        formatter = load_formatter
        puts formatter.format(calendar)
      end

      def load_formatter
        formatter_type = options.fetch(:formatter, :plain)

        require "denso/calendar/formatter/#{formatter_type}"
        Denso::Calendar::Formatter.const_get(formatter_type.to_s.capitalize).new
      end
    end
  end
end