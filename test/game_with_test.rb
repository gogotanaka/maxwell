require 'test_helper'

class GameWithScraper < Maxwell::Base
  attr_accessor :data

  def parser html
    @data = html.css("table.sorttable tr[data-col1] td:nth-child(1) a").map do |a|
      a.parent.parent.css("td").map &:text
    end
  end

  def handler result
    p result
  end
end

class GameWithTest < Minitest::Test
  urls = %w[
    http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/1798
    http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/283
    http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/284
  ]
  GameWithScraper.execute urls
end
