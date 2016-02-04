require 'test_helper'

class MaxwellTest < Minitest::Test
  def test_main
    assert_kind_of Nokogiri::HTML::Document, Maxwell::Converter.execute("https://www.google.com")

    binding.pry

    (1..7).to_a.each do |i|
      Maxwell.new("http://beauty.hotpepper.jp/svcSA/stc1170010/PN#{i}.html", "代官山.csv") do |root, csv|
        root.open_links("h3.slcHead.cFix a") do |html|
          url, address = nil, nil

          html.css("table.slnDataTbl.bdCell.bgThNml.fgThNml.vaThT.pCellV10H12 tr").map do |tr|
            if tr.css("th").text == "お店のホームページ"
              url = tr.css("td a").text
            end
            if tr.css("th").text == "住所"
              address = tr.css("td").text
            end
          end

          csv << [html.title.gsub("｜ホットペッパービューティー", ""), url, address]

        end
      end
    end



  end
end
