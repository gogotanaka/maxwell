require "maxwell/converter"
require 'csv'

class Maxwell
  def initialize(url, csv_path, &block)
    csv = CSV.open(csv_path, "a")
    block.call Maxwell::HTML(url), csv
    csv.close
  end

  def self.HTML(url)
    Maxwell::Converter.execute url
  end
end

class ::Nokogiri::HTML::Document
  def open_links(selector, &block)
    self.css(selector).map do |a|
      block.call Maxwell::HTML(a[:href])
    end
  end
end

class ::String
  def trim
    delete("\r\n\t")
  end
end
