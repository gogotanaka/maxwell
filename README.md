株式の情報取得するGem作ったよ！

# 2014/3/21 アップデートしたよ！
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
* 0.3.0 (2014-03-21)
  * もっといい感じにした


例
--------

https://github.com/gogotanaka/sorry_yahoo_finance

#SorryYahooFinance::GET

### 証券コードと日付を引数に SorryYahooFinance::Info のオブジェクト(該当株式の情報）の配列またはそれ自身を返す。

証券コードのみ指定した場合はその時点での情報をとってくる。

日付の渡し方は２パターン用意してある。

```ruby:ex1.rb
SorryYahooFinance::GET(8058)
=> #<SorryYahooFinance::Info:0x007ff7db73cfa0
 @values=
  {:code=>"8058",
   :name=>"三菱商事(株)",
   :market=>"東証1部 ",
   :industry=>"卸売業",
   :price=>"1,863",
   :previousprice=>"1,876",
   :opening=>"1,880",
   :high=>"1,893",
   :low=>"1,860",
   :turnover=>"7,359,200",
   :trading_volume=>"13,763,108",
   :price_limit=>"1,476～2,276",
   :margin_buying=>"6,763,500",
   :margin_selling=>"307,400",
   :d_margin_buying=>"+885,500",
   :d_margin_selling=>"-181,100",
   :margin_rate=>"22",
   :chart_image=>"http://gchart.yahoo.co.jp/f?s=8058.T"}>



SorryYahooFinance::GET(8606, Date(2014, 3, 20))
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


証券コードを複数渡した場合はSorryYahooFinance::Infoオブジェクトの配列を返す。

```ruby:ex3.rb
SorryYahooFinance::GET.get_by_codes([8606,8058])
=> [#<SorryYahooFinance::Info:0x007fcb2e4816a0 ...>, #<SorryYahooFinance::Info:0x007fcb30a17e78 ... >]


SorryYahooFinance::GET.get_by_codes([8606,8058], Date(2014, 3, 20))
=> [#<SorryYahooFinance::Info:0x007fcb2e4816a0 ...>, #<SorryYahooFinance::Info:0x007fcb30a17e78 ... >]


SorryYahooFinance::GET.get_by_codes([8606,8058], 2014, 3, 20)
=> [#<SorryYahooFinance::Info:0x007fcb2e4816a0 ...>, #<SorryYahooFinance::Info:0x007fcb30a17e78 ... >]


```

証券コード、その配列の代わりに:allというシンボルを渡せば全株式のSorryYahooFinance::Infoオブジェクトを取ってくる。

全株式の指すところはこのあたり参照

（http://www.tse.or.jp/market/data/listed_companies/)

```ruby:ex4.rb
SorryYahooFinance::GET.get_by_codes(:all)
=> .....(略)
```




# SorryYahooFinance::Infoクラスのあれこれ

SorryYahooFinance::GETによって作られるSorryYahooFinance::Infoについて



```ruby:ex5.rb
info = SorryYahooFinance::GET(8411)

info.values
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

SorryYahooFinance::Info#market などでそれぞれの情報

```ruby:ex6.rb
info.market
=> "東証1部"
```


SorryYahooFinance::Info#formalize_values でvaluesの各値をFixnumやRangeにしたものを返す。

```ruby:ex7.rb
info.formalize_values
=> {:code=>8411,
 :name=>"(株)みずほフィナンシャルグループ",
 :market=>"東証1部",
 :industry=>"銀行業",
 :price=>201,
 :previousprice=>203,
 :opening=>203,
 :high=>204,
 :low=>200,
 :turnover=>111785700,
 :trading_volume=>22552224,
 :price_limit=>123..283,
 :margin_buying=>370732000,
 :margin_selling=>7085000,
 :d_margin_buying=>36113200,
 :d_margin_selling=>-962200,
 :margin_rate=>52.33,
 :chart_image=>"http://gchart.yahoo.co.jp/f?s=8411.T"}
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
