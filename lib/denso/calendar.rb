# frozen_string_literal: true

require 'denso/calendar/version'
require 'denso/calendar/date'
require 'uri'
require 'nokogiri'
require 'net/http'

module Denso
  class Calendar
    URI = 'https://www.denso.com/jp/ja/about-us/calendar/'

    # Your code goes here...

    # Loads calendars from DENSO site
    #
    # @param type [Symbol] A calender type.
    # @return [Array[Denso::Calendar]]
    # @see Denso::Calendar::URI
    def self.load(type = :production)
      content = Net::HTTP.get(uri)
      doc = Nokogiri::HTML(content)
      tables = doc.xpath("//h2/a[@id='#{type}']/../../following-sibling::div[contains(@class, 'denso-calendar')][1]")

      Calendar.new(tables)
    end

    def self.uri
      @uri ||= ::URI.parse(URI)
    end

    # @return [Array[Denso::Calendar::Date]]
    attr_reader :days

    def initialize(tables_doc)
      @doc = tables_doc

      parse
    end

    # Returns all business days in the Calendar
    #
    # @return [Array[Denso::Calendar::Date]]
    # @see Denso::Calendar::Date#business_day?
    def business_days
      @business_days ||= days.select(&:business_day?)
    end

    # Returns all holidays in the Calendar
    #
    # @return [Array[Denso::Calendar::Date]]
    # @see Denso::Calendar::Date#holiday?
    def holidays
      @holidays ||= days.select(&:holiday?)
    end

    private

    def parse
      @days = []

      @doc.xpath('.//table').each do |table|
        caption = table.xpath('./caption/text()').to_s
        m = caption.match(/(\d{4})年(\d{1,2})月/)
        year = m[1].to_i
        month = m[2].to_i

        table.css('td').each do |element|
          day = element.content
          next if day !~ /\A\d+\Z/

          holiday = element['class'] && element['class'].include?('holiday')

          @days << Denso::Calendar::Date.new(year, month, day.to_i, holiday: holiday)
        end
      end
    end
  end
end
