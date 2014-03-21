SorryYahooFinance README
=============

株式の情報取得するGem作ったよ！

# 2014/2/21 アップデートしたよ！
--------

https://github.com/gogotanaka/sorry_yahoo_finance

https://rubygems.org/gems/sorry_yahoo_finance

株式の各種データをひっぱってきたいと思い、Gemを探したが以外となかったので作ってみた。

Yahoo!Japanファイナンス（http://finance.yahoo.co.jp/）

から株の情報をひっぱてきます。ごめんなさい。Yahoo!

今の所

* 証券コード
* 市場
* 業種
* 株価
* 前日終値
* 始値
* 高値
* 安値
* 出来高
* 売買代金
* 値幅制限
* 信用買残
* 信用買残前週比
* 信用売残
* 信用売残前週比
* 貸借倍率

を取ってきます。余裕があったらもっと増やします。

更新履歴
--------
* 0.1.0 (2014-02-15)
  * 一応形にした

* 0.2.0 (2014-02-20)
  * いい感じにした
例
--------

https://github.com/gogotanaka/sorry_yahoo_finance

### 証券コードと日付を引数に該当する株式の情報をひっぱってくる。

日付は省略可能

```ruby:ex1.rb
SorryYahooFinance::GET(8058, Date.new(2008, 9, 15))
=> #<SorryYahooFinance::GET:0x007fcb36260030>

SorryYahooFinance::GET(8606)
=> #<SorryYahooFinance::GET:0x007fcb2b6d53c8>
```

ちなみに SorryYahooFinance が長過ぎて無理な人のために Stock というエイリアスを張ってある。

```ruby:ex1.rb
Stock::GET(8058, Date.new(2008, 9, 15))
=> #<SorryYahooFinance::GET:0x007fcb36260030>

Stock::GET(8606)
=> #<SorryYahooFinance::GET:0x007fcb2b6d53c8>
```

SorryYahooFinance::GET#values　で株情報をhash形式で

```rb
SorryYahooFinance::GET(8411).values
=> {:code=>"8411",
 :name=>"(株)みずほフィナンシャルグループ",
 :market=>"東証1部",
 :industry=>"銀行業",
 :price=>"212",
 :previousprice=>"218",
 :opening=>"218",
 :high=>"218",
 :low=>"211",
 :turnover=>"197,084,500",
 :trading_volume=>"42,334,350",
 :price_limit=>"138～298",
 :margin_buying=>"320,352,600",
 :margin_selling=>"13,355,900",
 :d_margin_buying=>"+15,929,300",
 :d_margin_selling=>"-4,316,500",
 :margin_rate=>"23.99",
 :chart_image=>"http://gchart.yahoo.co.jp/f?s=8411.T"}
```

SorryYahooFinance::GET#market などでそれぞれの情報

```rb
SorryYahooFinance::GET(3333).market
=> "東証1部"
```

一応、複数も

```ruby:ex2.rb
SorryYahooFinance::GET.get_by_codes([8606,8058])
=> [#<SorryYahooFinance::GET:0x007fcb2e4816a0>, #<SorryYahooFinance::GET:0x007fcb30a17e78>

```

全株式もとって来れる（http://www.tse.or.jp/market/data/listed_companies/)
全株式の指す所はこのあたり参照

を取ってくる

```ruby:ex3.rb
SorryYahooFinance::GET.get_all
=> .....(略)
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
