require 'test_helper'
require 'csv'

class MaxwellTest < Minitest::Test
  def test_main
    assert_kind_of Nokogiri::HTML::Document, Maxwell::Converter.call("https://www.google.com")
  end
end
