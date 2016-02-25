require 'test_helper'

class GameWithScraper < Maxwell::Base
  attr_scrape :data

  regist_strategy do
    @data = @HTML.css("table.sorttable tr[data-col1] td:nth-child(1) a").map do |a|
      a.parent.parent.css("td").map &:text
    end
  end

  regist_handler do |result|

  end
end

class GameWithTest < Minitest::Test
  # %w[
  #   http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/1798
  #   http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/283
  #   http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/284
  # ].each do |url|
  #   GameWithScraper.new.execute url
  # end
end
