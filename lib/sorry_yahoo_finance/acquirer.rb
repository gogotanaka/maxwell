require "sorry_yahoo_finance/http_client"
require "sorry_yahoo_finance/decorator"

module SorryYahooFinance
  class Acquirer
    include Decorator

    attr_reader :stocks

    def initialize(codes, date_or_ary)
      date = build_date(date_or_ary)
      @stocks = if codes.count == 1
                  [get_one(codes.first, date)]
                else
                  get_some(codes, date)
                end
    end

    def get_one(code, date)
      if date
        scrape_with_date(code, date)
      else
        scrape_without_date(code)
      end
    end

    def get_some(codes, date)
      codes.map do |code|
        get_one(code, date)
      end
    end

    private

      def scrape_with_date(code, date)
        # TODO: ugly..
        year, month, day = date.strftime("%Y,%m,%d").split(",")
        month.delete!("0")
        url = "http://info.finance.yahoo.co.jp/history/?code=#{code}.T&sy=#{year}&sm=#{month}&sd=#{day}&ey=#{year}&em=#{month}&ed=#{day}&tm=d"
        html = HttpClient.get(url)

        tds = html.xpath("(//div[@id='main']//table)[2]//td")
        opening, high, low, finish, turnover = tds[1..5].map(&:text)
        {
          code:     code,
          name:     html.css('table.stocksTable th.symbol h1').inner_text,
          market:   html.css('div#ddMarketSelect span.stockMainTabName').inner_text,
          industry: html.css("div.stocksDtl dd.category a").text,
          opening:  opening,
          high:     high,
          low:      low,
          finish:   finish
        }
      end

      def scrape_without_date(code)
        # TODO: ugly..
        url = "http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{code}"
        html = HttpClient.get(url)

        previousprice, opening, high, low, turnover, trading_volume, price_limit = html.css('div.innerDate dd').map{|x| x.css('strong').inner_text }
        margin_deal = html.css("div.ymuiDotLine div.yjMS dd.ymuiEditLink strong").map(&:text)
        html.css('div#main div.main2colR div.chartFinance div.lineFi dl').map { |dl| dl.css('dd strong').text }
        capitalization, shares_outstanding, dividend_yield, dps, per, pbr, eps, bps, minimum_purchase, share_unit, yearly_high, yearly_low = html.css('div#main div.main2colR div.chartFinance div.lineFi dl').map { |dl| dl.css('dd strong').text }

        {
          code:               code,
          name:               html.css('table.stocksTable th.symbol h1').inner_text,
          market:             html.css('div#ddMarketSelect span.stockMainTabName').inner_text,
          industry:           html.css("div.stocksDtl dd.category a").text,
          price:              html.css('table.stocksTable td.stoksPrice')[1].content,
          previousprice:      previousprice,
          opening:            opening,
          high:               high,
          low:                low,
          turnover:           turnover,
          trading_volume:     trading_volume,
          price_limit:        price_limit,
          margin_buying:      margin_deal[0],
          margin_selling:     margin_deal[3],
          d_margin_buying:    margin_deal[1],
          d_margin_selling:   margin_deal[4],
          margin_rate:        margin_deal[2],
          capitalization:     capitalization,
          shares_outstanding: shares_outstanding,
          dividend_yield:     dividend_yield,
          dps:                dps,
          per:                per,
          pbr:                pbr,
          eps:                eps,
          bps:                bps,
          minimum_purchase:   minimum_purchase,
          share_unit:         share_unit,
          yearly_high:        yearly_high,
          yearly_low:         yearly_low,
          chart_image:        html.css("div.styleChart img")[0][:src],
        }
      end

      def build_date(date_or_ary)
        return unless date_or_ary

        case date_or_ary
        when Array
          fail 'Should supply three value for year, month and day' unless date_or_ary.count == 3
          Date.new(*date_or_ary)
        when Date
          date_or_ary
        end
      end

  end
end
