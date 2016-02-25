require 'test_helper'

class HotpepperScraper < Maxwell::Base
  attr_scrape :title, :url, :address

  regist_strategy("h3.slcHead.cFix a") do
    @title = @HTML.title.gsub("｜ホットペッパービューティー", "")

    @HTML.css("table.slnDataTbl.bdCell.bgThNml.fgThNml.vaThT.pCellV10H12 tr").map do |tr|
      if tr.css("th").text == "お店のホームページ"
        @url = tr.css("td a").text
      end
      if tr.css("th").text == "住所"
        @address = tr.css("td").text
      end
    end
  end

  regist_handler do |result|
    CSV.open("武蔵小杉・田園調布・新丸子・下丸子.csv", "a") do |csv|
      if result[:url]
        csv << [result[:url]]
        p result
      end
    end
  end
end

class HotpepperTest < Minitest::Test
  # (1..5).to_a.each do |i|
  #   HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/macAE/salon/sacX172/PN#{i}.html"
  # end
  # HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/stc1120015/"
  # HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/stc1120015/"
  # HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/stc1120015/"
end
