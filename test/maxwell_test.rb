require 'test_helper'

class HotpepperScraper < Maxwell::Base
  attr_scrape :title, :url, :address

  regist_strategy("h3.slcHead.cFix a") do
    @title = @html.title.gsub("｜ホットペッパービューティー", "")

    @html.css("table.slnDataTbl.bdCell.bgThNml.fgThNml.vaThT.pCellV10H12 tr").map do |tr|
      if tr.css("th").text == "お店のホームページ"
        @url = tr.css("td a").text
      end
      if tr.css("th").text == "住所"
        @address = tr.css("td").text
      end
    end
  end

  regist_handler do |result|
    p result
  end
end

class MaxwellTest < Minitest::Test
  def test_main
    assert_kind_of Nokogiri::HTML::Document, Maxwell::Converter.execute("https://www.google.com")

    HotpepperScraper.new.execute("http://beauty.hotpepper.jp/svcSA/stc1170010/PN1.html")
  end
end
