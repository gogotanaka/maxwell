require 'test_helper'

class MaxwellTest < Minitest::Test
  def test_main
    assert_kind_of Nokogiri::HTML::Document, Maxwell::Converter.execute("https://www.google.com")

    (1..7).to_a.each do |i|
      Maxwell::DO({
        "http://beauty.hotpepper.jp/svcSA/stc1170010/PN#{i}.html" => {
          "h3.slcHead.cFix a" => ->(html) {
            url, address = nil, nil
            html.css("table.slnDataTbl.bdCell.bgThNml.fgThNml.vaThT.pCellV10H12 tr").map do |tr|
              if tr.css("th").text == "お店のホームページ"
                url = tr.css("td a").text
              end
              if tr.css("th").text == "住所"
                address = tr.css("td").text
              end
            end
            [html.title.gsub("｜ホットペッパービューティー", ""), url, address]
          }
        }
      }) do |result|
        p result
      end
    end
  end
end
