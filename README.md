株式の情報取得するGem作ったよ！

# バグ報告頂いてから２４時間以内に必ず直します。（という気概です）
--------

株式の各種データをひっぱってきたいと思い、Gemを探したが以外となかったので作ってみた。

Yahoo!Japanファイナンス（http://finance.yahoo.co.jp/）

から株の情報をひっぱてきます。ごめんなさい。Yahoo!

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

を取ってきます。余裕があったらもっと増やします。




SorryYahooFinance::GET
--------

証券コードと日付を引数に SorryYahooFinance::Info のオブジェクト(該当株式の情報）の配列またはそれ自身を返す。

証券コードのみ指定した場合はその時点での情報をとってくる。

日付の渡し方は２パターン用意してある。

```ruby:ex1.rb
SorryYahooFinance::GET(8058)
=> #<SorryYahooFinance::Info:0x007ff1448cc138
 @values=
  {:code=>8058,
   :name=>"三菱商事(株)",
   :market=>"卸売業",
   :industry=>"卸売業",
   :price=>"2,239",
   :previousprice=>"2,233.5",
   :opening=>"2,238",
   :high=>"2,242",
   :low=>"2,222",
   :turnover=>"4,810,700",
   :trading_volume=>"10,756,261",
   :price_limit=>"1,733.5～2,733.5",
   :margin_buying=>"2,861,600",
   :margin_selling=>"1,782,300",
   :d_margin_buying=>"+2,700",
   :d_margin_selling=>"+296,100",
   :margin_rate=>"1.61",
   :capitalization=>"3,636,218",
   :shares_outstanding=>"1,624,036,751",
   :dividend_yield=>"3.13",
   :dps=>"70.00",
   :per=>"(連) 9.20",
   :pbr=>"(連) 0.66",
   :eps=>"(連) 243.38",
   :bps=>"(連) 3,384.95",
   :minimum_purchase=>"223,900",
   :share_unit=>"100",
   :yearly_high=>"2,242",
   :yearly_low=>"1,767",
   :chart_image=>"http://chart.yahoo.co.jp/?code=8058.T&tm=1d&size=e&vip=off"}>

SorryYahooFinance::GET(8058, Date.new(2014, 3, 20))
=> #<SorryYahooFinance::Info:0x007fcb2b6d53c8 ...

SorryYahooFinance::GET(8058, 2014, 3, 20)
=> #<SorryYahooFinance::Info:0x007fcb36260030 ...
```

ちなみに SorryYahooFinance が長過ぎて無理な人のために Stock というエイリアスを張ってある。

```ruby:ex2.rb
Stock::GET(8058, Date.new(2008, 9, 15))
=> #<SorryYahooFinance::Info:0x007fcb36260030>

Stock::GET(8606)
=> #<SorryYahooFinance::Info:0x007fcb2b6d53c8>
```


証券コードの配列を渡した場合はSorryYahooFinance::Infoオブジェクトの配列を返す。

```ruby:ex3.rb
SorryYahooFinance::GET([8411,8058])
=>
[
  #<SorryYahooFinance::Info:0x007ff146159728
    @values=
     {:code=>8411,
      :name=>"(株)みずほフィナンシャルグループ",`
    ...
  >,
  #<SorryYahooFinance::Info:0x007ff144b7d8a0
    @values=
     {:code=>8058,
      :name=>"三菱商事(株)",
    ...
  >
]

SorryYahooFinance::GET([8606,8058], Date.new(2014, 3, 20))

SorryYahooFinance::GET([8606,8058], 2014, 3, 20)
```

証券コード、その配列の代わりに:allというシンボルを渡せば全株式のSorryYahooFinance::Infoオブジェクトを取ってくる。

全株式の指すところはこのあたり参照

（http://www.tse.or.jp/market/data/listed_companies/)

```ruby:ex4.rb
SorryYahooFinance::GET(:all)
=> .....(略)
```




SorryYahooFinance::Infoクラスのあれこれ
--------

SorryYahooFinance::GETによって作られるSorryYahooFinance::Infoについて


```ruby:ex5.rb
info = SorryYahooFinance::GET(8411)

# SorryYahooFinance::Info#values
# 各指標のhashを返す（指標名: 値)

info.values
=> {
  :code=>8411,
  :name=>"(株)みずほフィナンシャルグループ",
  :market=>"銀行業",
  :industry=>"銀行業",
  :price=>"203.8",
  :previousprice=>"202.9",
  :opening=>"203.7",
  :high=>"204.3",
  :low=>"203.4",
  :turnover=>"113,507,800",
  :trading_volume=>"23,141,831",
  :price_limit=>"122.9～282.9",
  :margin_buying=>"347,768,200",
  :margin_selling=>"8,394,300",
  :d_margin_buying=>"-46,301,900",
  :d_margin_selling=>"+3,720,600",
  :margin_rate=>"41.43",
  :capitalization=>"4,950,638",
  :shares_outstanding=>"24,291,647,947",
  :dividend_yield=>"3.43",
  :dps=>"7.00",
  :per=>"(連) 8.99",
  :pbr=>"(連) 0.73",
  :eps=>"(連) 22.67",
  :bps=>"(連) 278.04",
  :minimum_purchase=>"20,380",
  :share_unit=>"100",
  :yearly_high=>"240",
  :yearly_low=>"193",
  :chart_image=>"http://chart.yahoo.co.jp/?code=8411.T&tm=1d&size=e&vip=off"
}

# SorryYahooFinance::Info#ja_values
# 各指標のhashを返す（キーが日本語）（指標名: 値)

info.ja_values
=> {
  "証券コード"=>8411,
  "銘柄名"=>"(株)みずほフィナンシャルグループ",
  "取引市場"=>"銀行業",
  "業種"=>"銀行業",
  "株価"=>"203.8",
  "前日終値"=>"202.9",
  "始値"=>"203.7",
  "高値"=>"204.3",
  "安値"=>"203.4",
  "出来高"=>"113,507,800",
  "売買代金"=>"23,141,831",
  "値幅制限"=>"122.9～282.9",
  "信用買残"=>"347,768,200",
  "信用売残"=>"8,394,300",
  "信用買残前週比"=>"-46,301,900",
  "信用売残前週比"=>"+3,720,600",
  "貸借倍率"=>"41.43",
  "時価総額"=>"4,950,638",
  "発行済株式数"=>"24,291,647,947",
  "配当利回り（会社予想）"=>"3.43",
  "1株配当（会社予想）"=>"7.00",
  "PER（会社予想）"=>"(連) 8.99",
  "PBR（実績）"=>"(連) 0.73",
  "EPS（会社予想）"=>"(連) 22.67",
  "BPS（実績）"=>"(連) 278.04",
  "最低購入代金"=>"20,380",
  "単元株数"=>"100",
  "年初来高値"=>"240",
  "年初来安値"=>"193",
  "チャート図"=>"http://chart.yahoo.co.jp/?code=8411.T&tm=1d&size=e&vip=off"
}

# SorryYahooFinance::Info#formalize_values
# #valuesの値をIntergerやRangeに整形した各指標のhashを返す（指標名: 値)

info.formalize_values
=> {
  :code=>8411,
  :name=>"(株)みずほフィナンシャルグループ",
  :market=>"銀行業",
  :industry=>"銀行業",
  :price=>203,
  :previousprice=>202,
  :opening=>203,
  :high=>204,
  :low=>203,
  :turnover=>113507800,
  :trading_volume=>23141831,
  :price_limit=>9..282,
  :margin_buying=>347768200,
  :margin_selling=>8394300,
  :d_margin_buying=>-46301900,
  :d_margin_selling=>3720600,
  :margin_rate=>41.43,
  :capitalization=>4950638,
  :shares_outstanding=>24291647947,
  :dividend_yield=>3.43,
  :dps=>7.0,
  :per=>"(連) 8.99",
  :pbr=>"(連) 0.73",
  :eps=>"(連) 22.67",
  :bps=>"(連) 278.04",
  :minimum_purchase=>20380,
  :share_unit=>100,
  :yearly_high=>240,
  :yearly_low=>193,
  :chart_image=>"http://chart.yahoo.co.jp/?code=8411.T&tm=1d&size=e&vip=off"
}

# SorryYahooFinance::Info#code, SorryYahooFinance::Info#name, ....
# 各指標の値を返す.

info.code
=> 8411

info.yearly_high
=> 240
```

LICENSE
-------
(The MIT License)

Copyright (c) 2014 GoGoTanaka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
