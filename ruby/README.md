日本国内株式の情報取得するGem.

[![Gem Version](https://badge.fury.io/rb/sorry_yahoo_finance.svg)](http://badge.fury.io/rb/sorry_yahoo_finance) [![Build Status](https://travis-ci.org/gogotanaka/sorry_yahoo_finance.svg?branch=master)](https://travis-ci.org/gogotanaka/sorry_yahoo_finance)

# バグ報告頂いてから２４時間以内に必ず直します.（という気概です）
--------

Yahoo!Japanファイナンス ( http://finance.yahoo.co.jp/ )

から株の情報を適切なデータ型(`Integer`, `Float`, `Range`..)にしてRubyの`Hash`オブジェクトで返します（ピュア！）.

ごめんなさい、Yahoo!

今の所
```
[
  "証券コード",
  "銘柄名",
  "取引市場",
  "業種",
  "株価",
  "前日終値",
  "始値",
  "高値",
  "安値",
  "出来高",
  "売買代金",
  "値幅制限",
  "信用買残",
  "信用売残",
  "信用買残前週比",
  "信用売残前週比",
  "貸借倍率",
  "時価総額",
  "発行済株式数",
  "配当利回り（会社予想）",
  "1株配当（会社予想）",
  "PER（会社予想）",
  "PBR（実績）",
  "EPS（会社予想）",
  "BPS（実績）",
  "最低購入代金",
  "単元株数",
  "年初来高値",
  "年初来安値",
  "チャート図"
]
```

を取ってきます。余裕があったらもっと増やします.

インストール
--------

    $ gem install sorry_yahoo_finance

または

    $ echo "gem 'sorry_yahoo_finance'" >> Gemfile
    $ bundle

でGemをインストール

使い方
--------

`YahooFinance.find`で株価の情報をHashまたはHashの配列で受け取る.


```rb
# 証券コードを１つ指定
YahooFinance.find(8058)
=>{
    "証券コード"=>8058,
    "銘柄名"=>"三菱商事(株)",
    "取引市場"=>"東証1部",
    "業種"=>"卸売業",
    "株価"=>2030,
    "前日終値"=>2037,
    "始値"=>2015,
    "高値"=>2031,
    "安値"=>2000,
    "出来高"=>6705900,
    "売買代金"=>13495988,
    "値幅制限"=>1537..2537,
    "信用買残"=>4071100,
    "信用売残"=>592600,
    "信用買残前週比"=>574300,
    "信用売残前週比"=>-167100,
    "貸借倍率"=>6.87,
    "時価総額"=>3297607,
    "発行済株式数"=>1624036751,
    "配当利回り（会社予想）"=>3.45,
    "1株配当（会社予想）"=>70.0,
    "PER（会社予想）"=>"(連) 8.28",
    "PBR（実績）"=>"(連) 0.57",
    "EPS（会社予想）"=>"\n(連) 245.17",
    "BPS（実績）"=>"\n(連) 3,568.72",
    "最低購入代金"=>203050,
    "単元株数"=>100,
    "年初来高値"=>2356,
    "年初来安値"=>1767,
    "チャート図"=>"http://chart.yahoo.co.jp/?code=8058.T&tm=1d&size=e&vip=off"
  }

# 証券コードを複数指定
YahooFinance.find(8606, 8058)
=>[
    {
      "証券コード"=>8606,
      "銘柄名"=>"みずほ証券(株)",
      "取引市場"=>"東証1部",
      "業種"=>"証券業",
      "株価"=>210,
      ...
    },
    {
      "証券コード"=>8058,
      "銘柄名"=>"三菱商事(株)",
      "取引市場"=>"東証1部",
      "業種"=>"卸売業",
      "株価"=>1880,
      ...
    }
]


# ラベルを英語で
YahooFinance.find(8606, 8058, lang: :en)
=>{
    :code=>8606,
    :name=>"みずほ証券(株)",
    :market=>"東証1部",
    :industry=>"証券業",
    :price=>0,
    :previousprice=>165
    ...
  }
  
# ラベルを英語で複数
YahooFinance.find(8606, lang: :en)
=>[
    {
      :code=>8606,
      :name=>"みずほ証券(株)",
      :market=>"東証1部",
      :industry=>"証券業",
      :price=>0,
      :previousprice=>165
      ...
    },
    {
      :code=>8058,
      :name=>"三菱商事(株)",
      :market=>"東証1部",
      :industry=>"卸売業",
      :price=>2437,
      :previousprice=>2431,
      ...
    }
]

# 日付を指定、その１
YahooFinance.find(8058, date: Date.new(2014, 3, 20))
=>{
    "証券コード"=>8058,
    "銘柄名"=>"三菱商事(株)",
    "取引市場"=>"東証1部",
    "業種"=>"卸売業",
    "始値"=>1880,
    "高値"=>1893,
    "安値"=>1860,
    "終値"=>1863
  }

# 日付を指定、その２
YahooFinance.find(8058, date: [2014, 3, 20])
=>{
  "証券コード"=>8058,
  "銘柄名"=>"三菱商事(株)",
  "取引市場"=>"東証1部",
  "業種"=>"卸売業",
  "始値"=>1880,
  "高値"=>1893,
  "安値"=>1860,
  "終値"=>1863
}

# 日付を複数指定
* `format: :json`を指定しない場合はdateの値はDateオブジェクトになります.
* 証券コードと日付をどちらも複数していする事は出来ません.（2015-1-14現在）
JSON.parse(YahooFinance.find(8058, date: Date.new(2014, 3, 28) .. Date.new(2014, 4, 3), format: :json, lang: :en))
=>{
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
  }


# フォーマットをjsonで
YahooFinance.find(8606, format: :json, lang: :en)
=> "{\"code\":8606,\"name\":\"みずほ証券(株)\",\"market\":\"東証1部\",\"industry\":\"証券業\",\"price\":0,\"previousprice\":165,\"opening\":0,\"high\":0,\"low\":0,\"turnover\":0,\"trading_volume\":0,\"price_limit\":\"0..0\",\"margin_buying\":1070000,\"margin_selling\":90000,\"d_margin_buying\":-3343000,\"d_margin_selling\":-748000,\"margin_rate\":11.89,\"capitalization\":262629,\"shares_outstanding\":1591688683,\"dividend_yield\":0.0,\"dps\":0.0,\"per\":\"(連) ---\",\"pbr\":\"(連) 0.49\",\"eps\":\"\\n---\",\"bps\":\"\\n(連) 334.82\",\"minimum_purchase\":165000,\"share_unit\":1000,\"yearly_high\":254,\"yearly_low\":162,\"chart_image\":\"http://chart.yahoo.co.jp/?code=8606.T&tm=1d&size=e&vip=off\"}"


# 全部盛り
YahooFinance.find(8604, 8058, date: Date.new(2014, 12, 1), lang: :en)
=>[
    {
      :code=>8604,
      :name=>"野村ホールディングス(株)",
      :market=>"東証1部",
      :industry=>"証券業",
      :opening=>716,
      :high=>726,
      :low=>710,
      :finish=>718
    },
    {
      :code=>8058,
      :name=>"三菱商事(株)",
      :market=>"東証1部",
      :industry=>"卸売業",
      :opening=>2260,
      :high=>2278,
      :low=>2215,
      :finish=>2222
    }
  ]

```