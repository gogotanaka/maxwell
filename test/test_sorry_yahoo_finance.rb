require 'minitest_helper'

class TestSorryYahooFinance < MiniTest::Unit::TestCase
  FULL_JA_LABEL = ["証券コード", "銘柄名", "取引市場", "業種", "株価", "前日終値", "始値", "高値", "安値", "出来高", "売買代金", "値幅制限", "信用買残", "信用売残", "信用買残前週比", "信用売残前週比", "貸借倍率", "時価総額", "発行済株式数", "配当利回り（会社予想）", "1株配当（会社予想）", "PER（会社予想）", "PBR（実績）", "EPS（会社予想）", "BPS（実績）", "最低購入代金", "単元株数", "年初来高値", "年初来安値", "チャート図"]

  FULL_EN_LABEL = [:code, :name, :market, :industry, :price, :previousprice, :opening, :high, :low, :turnover, :trading_volume, :price_limit, :margin_buying, :margin_selling, :d_margin_buying, :d_margin_selling, :margin_rate, :capitalization, :shares_outstanding, :dividend_yield, :dps, :per, :pbr, :eps, :bps, :minimum_purchase, :share_unit, :yearly_high, :yearly_low, :chart_image]

  SHORT_JA_LABEL = ["証券コード", "銘柄名", "取引市場", "業種", "始値", "高値", "安値", "終値"]
  SHORT_EN_LABEL = [:code, :name, :market, :industry, :opening, :high, :low, :finish]
  def test_that_it_has_a_version_number
    refute_nil ::SorryYahooFinance::VERSION
  end

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
end
