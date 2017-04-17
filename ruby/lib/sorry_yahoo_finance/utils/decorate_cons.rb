module DecorateCons
  INT_KEYS = [
    :price,
    :previousprice,
    :opening,
    :high,
    :low,
    :turnover,
    :trading_volume,
    :margin_buying,
    :margin_selling,
    :d_margin_buying,
    :d_margin_selling,
    :finish,
    :capitalization,
    :shares_outstanding,
    :minimum_purchase,
    :share_unit,
    :yearly_high,
    :yearly_low
  ]

  FLOAT_KEYS = [
    :margin_rate,
    :dividend_yield,
    :dps
  ]

  JA_RABEL_HASH = {
    code: "証券コード",
    name: "銘柄名",
    market: "取引市場",
    industry: "業種",
    price: "株価",
    previousprice: "前日終値",
    opening: "始値",
    high: "高値",
    low: "安値",
    finish: "終値",
    turnover: "出来高",
    trading_volume: "売買代金",
    price_limit: "値幅制限",
    margin_buying: "信用買残",
    margin_selling: "信用売残",
    d_margin_buying: "信用買残前週比",
    d_margin_selling: "信用売残前週比",
    margin_rate: "貸借倍率",
    capitalization: "時価総額",
    shares_outstanding: "発行済株式数",
    dividend_yield: "配当利回り（会社予想）",
    dps: "1株配当（会社予想）",
    per: "PER（会社予想）",
    pbr: "PBR（実績）",
    eps: "EPS（会社予想）",
    bps: "BPS（実績）",
    minimum_purchase: "最低購入代金",
    share_unit: "単元株数",
    yearly_high: "年初来高値",
    yearly_low: "年初来安値",
    chart_image: "チャート図",
    prices: "価格"
  }
end
