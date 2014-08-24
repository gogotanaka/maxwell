require 'utils/converter'
require 'utils/hash_accessor'

require 'yaml'

module SorryYahooFinance
  class Info
    INT_KEYS = [
      :code,
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
      :finish
    ]

    extend HashAccessor
    hash_accessor :values, :code, :name, :market, :industry, :price, :previousprice, :opening, :high, :low, :turnover, :trading_volume, :price_limit, :margin_buying, :margin_selling, :d_margin_buying, :d_margin_selling, :margin_rate, :chart_image

    # TODO: 休場の時はアラート出したい
    def initialize(code, date=nil)
      if code.class == Fixnum && code.to_s.size == 4
        begin
          @values = date ? infos_with_date(code, date) : infos(code)
        rescue => ex
          raise "code #{code} stock dont exist. #{ex}"
        end
      else
        raise "code #{code} must be a four-digit number."
      end
    end

    def values
      @values
    end

    def ja_values
      Hash[
        @values.to_a.map { |ary| [ja_rabels[ary[0]], ary[1]] }
      ]
    end

    def formalize_values
      return_values = @values

      INT_KEYS.each do |key|
        if return_values[key].class == String
          return_values[key] = return_values[key].to_int
        end
      end

      # to_range(str is like 183〜201)
      return_values[:price_limit] = return_values[:price_limit].to_range

      # to_f
      return_values[:margin_rate] = return_values[:margin_rate].to_f

      return_values
    end

    class ::String
      def to_int
        delete(",").to_i
      end

      def to_range
        delete!(",")
        self =~ /(\d+)～(\d+)/
        Range.new($1.to_i,$2.to_i)
      end
    end

    private

      def infos(code)
        url = yahoo_url(code)
        html = Converter.execute(url)
        previousprice, opening, high, low, turnover, trading_volume, price_limit = html.css('div.innerDate dd').map{|x| x.css('strong').inner_text }
        margin_deal = html.css("div.ymuiDotLine div.yjMS dd.ymuiEditLink strong").map(&:text)
        {
          code:             code,
          name:             html.css('table.stocksTable th.symbol h1').inner_text,
          market:           html.css('div.stocksDtlWp dd')[0].content,
          industry:         html.css("div.stocksDtl dd.category a").text,
          price:            html.css('table.stocksTable td.stoksPrice')[1].content,
          previousprice:    previousprice,
          opening:          opening,
          high:             high,
          low:              low,
          turnover:         turnover,
          trading_volume:   trading_volume,
          price_limit:      price_limit,
          margin_buying:    margin_deal[0],
          margin_selling:   margin_deal[3],
          d_margin_buying:  margin_deal[1],
          d_margin_selling: margin_deal[4],
          margin_rate:      margin_deal[2],
          chart_image:      html.css("div.styleChart img")[0][:src],
        }
      end

      def infos_with_date(code, date)
        url = yahoo_url_with_date(code, date)
        html = Converter.execute(url)
        tds = html.xpath("(//div[@id='main']//table)[2]//td")
        opening, high, low, finish, turnover = tds[1..5].map(&:text)
        {
          code:     html.css("div#divAddPortfolio + dl dt").text,
          name:     html.css('table.stocksTable th.symbol h1').inner_text,
          market:   html.css('div.stocksDtlWp dd')[0].content,
          industry: html.css("div.stocksDtl dd.category a").text,
          opening:  opening,
          high:     high,
          low:      low,
          finish:   finish
        }
      end

      def ja_rabels
        # YAML.load_file('lib/utils/ja.yml').inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        {
          :code=>"証券コード",
          :name=>"銘柄名",
          :market=>"取引市場",
          :industry=>"業種",
          :price=>"株価",
          :previousprice=>"前日終値",
          :opening=>"証券コード",
          :high=>"高値",
          :low=>"安値",
          :turnover=>"出来高",
          :trading_volume=>"売買代金",
          :price_limit=>"値幅制限",
          :margin_buying=>"信用買残",
          :margin_selling=>"信用売残",
          :d_margin_buying=>"信用買残前週比",
          :d_margin_selling=>"信用売残前週比",
          :margin_rate=>"貸借倍率",
          :chart_image=>"チャート図"
        }
      end

      def yahoo_url(code)
        "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{code}"
      end

      def yahoo_url_with_date(code, date)
        year, month, day = date.strftime("%Y,%m,%d").split(",")
        month.delete!("0")
        "http://info.finance.yahoo.co.jp/history/?code=#{code}.T&sy=#{year}&sm=#{month}&sd=#{day}&ey=#{year}&em=#{month}&ed=#{day}&tm=d"
      end
  end
end
