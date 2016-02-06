require 'nokogiri'
require 'httpclient'

class Maxwell
  module Converter
    def self.execute(url)
      client = HTTPClient.new(
        default_header: {
          "User-Agent" => @user_agent
        }
      )

      html = begin
        client.get_content(url)
      rescue
        ""
      end

      Nokogiri::HTML(html)
    end
  end
end
