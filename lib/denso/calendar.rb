# frozen_string_literal: true

require 'denso/calendar/version'
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
      tables = doc.xpath("//h2/a[@id='#{type}']/../../following-sibling::div[contains(@class, 'denso-calendar')]")

      Calendar.new(tables)
    end

    def self.uri
      @uri ||= ::URI.parse(URI)
    end

    attr_reader :holidays

    def initialize(tables_doc)
      @doc = tables_doc

      parse
    end

    private

    def parse
      @holidays = []

      @doc.xpath('//table').each do |table|
        caption = table.xpath('//caption/text()').to_s
        m = caption.match(/(\d{4})年(\d{2})月/)
        year = m[1].to_i
        month = m[2].to_i

        table.css('td.holiday').each do |element|
          @holidays << Date.new(year, month, element.content.to_i)
        end
      end

      @holidays
    end
  end
end
