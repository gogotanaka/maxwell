require 'minitest_helper'

class TestSorryYahooFinance < MiniTest::Unit::TestCase
  FULL_JA_LABEL = ["証券コード", "銘柄名", "取引市場", "業種", "株価", "前日終値", "始値", "高値", "安値", "出来高", "売買代金", "値幅制限", "信用買残", "信用売残", "信用買残前週比", "信用売残前週比", "貸借倍率", "時価総額", "発行済株式数", "配当利回り（会社予想）", "1株配当（会社予想）", "PER（会社予想）", "PBR（実績）", "EPS（会社予想）", "BPS（実績）", "最低購入代金", "単元株数", "年初来高値", "年初来安値", "チャート図"]

  FULL_EN_LABEL = [:code, :name, :market, :industry, :price, :previousprice, :opening, :high, :low, :turnover, :trading_volume, :price_limit, :margin_buying, :margin_selling, :d_margin_buying, :d_margin_selling, :margin_rate, :capitalization, :shares_outstanding, :dividend_yield, :dps, :per, :pbr, :eps, :bps, :minimum_purchase, :share_unit, :yearly_high, :yearly_low, :chart_image]

  SHORT_JA_LABEL = ["証券コード", "銘柄名", "取引市場", "業種", "始値", "高値", "安値", "終値", "出来高"]
  SHORT_EN_LABEL = [:code, :name, :market, :industry, :opening, :high, :low, :finish, :turnover]

  # TODO: Opposite..
  def test_find
    assert_equal(
      YahooFinance.find(8058).keys,
      FULL_JA_LABEL
    )

    assert_equal(
      YahooFinance.find(8058, date: Date.new(2014, 3, 20)).keys,
      SHORT_JA_LABEL
    )

    assert_equal(
      YahooFinance.find(8058, date: [2014, 3, 20], lang: :en).keys,
      SHORT_EN_LABEL
    )

    assert_equal(
      YahooFinance.find(8606, 8058, lang: :en).first.keys,
      FULL_EN_LABEL
    )

    assert_equal(
      YahooFinance.find(8606, 8058, date: Date.new(2014, 3, 20), lang: :en).first.keys,
      SHORT_EN_LABEL
    )

    assert_equal(
      YahooFinance.find(8606, 8058, date: [2014, 3, 20], format: false)[1].keys,
      SHORT_JA_LABEL
    )
  end

  def test_json
    assert_equal(
      "{\"証券コード\":8058,\"銘柄名\":\"三菱商事(株)\",\"取引市場\":\"東証1部\",\"業種\":\"卸売業\",\"始値\":\"1,880\",\"高値\":\"1,893\",\"安値\":\"1,860\",\"終値\":\"1,863\",\"出来高\":\"7,359,200\"}",
      YahooFinance.find(8606, 8058, date: [2014, 3, 20], format: :json)[1]
    )

    assert_equal(
      "{\"code\":8058,\"name\":\"三菱商事(株)\",\"market\":\"東証1部\",\"industry\":\"卸売業\",\"opening\":1880,\"high\":1893,\"low\":1860,\"finish\":1863,\"turnover\":7359200}",
      YahooFinance.find(8606, 8058, date: [2014, 3, 20], format: :json, lang: :en)[1]
    )

    assert_equal(
      {
        "code"=>8058,
        "name"=>"三菱商事(株)",
        "market"=>"東証1部",
        "industry"=>"卸売業",
        "prices"=>
        [
          {"opening"=>1863, "high"=>1879, "low"=>1838, "finish"=>1879, "turnover"=>5558500, "date"=>"2014-03-28"},
          {"opening"=>1891, "high"=>1920, "low"=>1891, "finish"=>1916, "turnover"=>6580800, "date"=>"2014-03-31"},
          {"opening"=>1915, "high"=>1925, "low"=>1903, "finish"=>1919, "turnover"=>4873600, "date"=>"2014-04-01"},
          {"opening"=>1923, "high"=>1944, "low"=>1910, "finish"=>1921, "turnover"=>6388600, "date"=>"2014-04-02"},
          {"opening"=>1935, "high"=>1943, "low"=>1921, "finish"=>1930, "turnover"=>5344400, "date"=>"2014-04-03"}
        ]
      },
      JSON.parse(YahooFinance.find(8058, date: Date.new(2014, 3, 28) .. Date.new(2014, 4, 3), format: :json, lang: :en))
    )
  end

  # def test_csv_dump
  #   YahooFinance.csv_dump("./tmp", 8058, date: Date.new(2014, 3, 28) .. Date.new(2014, 4, 3) )
  # end
end
