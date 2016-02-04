require 'nokogiri'
require 'httpclient'

class Maxwell
  module Converter
    def self.execute(url)
      client = HTTPClient.new(default_header: {"User-Agent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"})

      html = begin
        client.get_content(url)
      rescue
        ""
      end

      Nokogiri::HTML(html)
    end
  end
end
