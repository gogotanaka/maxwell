require 'test_helper'
require 'csv'

class HotpepperScraper < Maxwell::Base
  attr_scrape :title, :url, :address

  concurrency 5

  regist_strategy do |html|
    @title = html.title.gsub("｜ホットペッパービューティー", "")

    html.css("table.slnDataTbl.bdCell.bgThNml.fgThNml.vaThT.pCellV10H12 tr").map do |tr|
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

class HotpepperTest < Minitest::Test
  urls = (1..17).map { |i|
    "http://beauty.hotpepper.jp/svcSA/macAP/salon/PN#{i}.html"
  }.map { |url| Maxwell::Opener.call(url, "h3.slcHead.cFix a") }.flatten

  scraper = HotpepperScraper.new urls
  scraper.execute
end
