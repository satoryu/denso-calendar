# frozen_string_literal: true

require 'denso/calendar/version'
require 'uri'
require 'net/http'

module Denso
  module Calendar
    URI = 'https://www.denso.com/jp/ja/about-us/calendar/'

    class Error < StandardError; end
    # Your code goes here...

    def self.load
      Net::HTTP.get(uri)
    end

    def self.uri
      @uri ||= ::URI.parse(URI)
    end
  end
end
