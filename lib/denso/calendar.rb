# frozen_string_literal: true

require 'denso/calendar/version'
require 'uri'
require 'nokogiri'
require 'net/http'

module Denso
  class Calendar
    URI = 'https://www.denso.com/jp/ja/about-us/calendar/'

    class Error < StandardError; end
    # Your code goes here...

    # Loads calendars from DENSO site
    #
    # @param type [Symbol] A calender type.
    # @return [Array[Denso::Calendar]]
    # @see Denso::Calendar::URI
    def self.load(type = :production)
      content = Net::HTTP.get(uri)
      doc = Nokogiri::HTML(content)
      doc.xpath("//h2/a[@id='#{type}']/../../following-sibling::div[contains(@class, 'denso-calendar')]")
      tables = doc.xpath('table')
      @calendars = tables.map { |table| Denso::Calendar.new(table) }
    end

    def self.uri
      @uri ||= ::URI.parse(URI)
    end

    attr_reader :year, :month, :holidays

    def initialize(table_doc)
      @doc = table_doc

      parse
    end

    def holidays
      @doc.css('td.holiday')

      [Date.today]
    end

    private

    def parse
      caption = @doc.xpath('//table/caption/text()').to_s
      caption.match(/(\d{4})年(\d{2})月/) do |m|
        @year = m[1].to_i
        @month = m[2].to_i
      end
    end
  end
end
