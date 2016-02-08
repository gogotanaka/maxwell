require 'test_helper'
require 'csv'

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
    CSV.open("青山・外苑前.csv", "a") do |csv|
      if result[:url]
        csv << [result[:url]]
        p result
      end
    end
  end
end

class GameWithScraper < Maxwell::Base
  attr_scrape :data

  regist_strategy do
    @data = @html.css("table.sorttable tr[data-col1] td:nth-child(1) a").map do |a|
      a.parent.parent.css("td").map &:text
    end
  end

  regist_handler do |result|
    binding.pry
  end
end

class MaxwellTest < Minitest::Test
  def test_main
    assert_kind_of Nokogiri::HTML::Document, Maxwell::Converter.execute("https://www.google.com")

    # HotpepperScraper.new.execute("http://beauty.hotpepper.jp/svcSA/stc1170010/PN1.html")
    %w[
      http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/1798
      http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/283
      http://xn--eckwa2aa3a9c8j8bve9d.gamewith.jp/article/show/284
    ].each do |url|
      GameWithScraper.new.execute url
    end

    # (1..6).to_a.each do |i|
    #   HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/macJR/salon/sacX566/PN#{i}.html"
    # end
    # HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/stc1120015/"
    # HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/stc1120015/"
    # HotpepperScraper.new.execute "http://beauty.hotpepper.jp/svcSA/stc1120015/"
  end
end
