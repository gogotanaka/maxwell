require "sorry_yahoo_finance/version"
require 'sorry_yahoo_finance/info'

require 'utils/all_stock_codes'

module SorryYahooFinance
  class << self
    def GET(code_or_codes_or_sym, date_or_year=nil, month=nil, day=nil)
      codes = build_codes(code_or_codes_or_sym)
      date  = build_date(date_or_year, month, day)
      GET.execute(codes, date)
    end

    private
      def build_codes(code_or_codes_or_sym)
        case code_or_codes_or_sym
        when :all
          AllStockCodes::CODES
        when Array
          code_or_codes_or_sym
        else
          [code_or_codes_or_sym]
        end
      end

      def build_date(date_or_year, month, day)
        if month && day
          Date.new(date_or_year, month, day)
        else
          date_or_year
        end
      end
  end

  module GET
    def execute(codes, date)
      infos = codes.map { |code| Info.new(code, date) }
      infos.count == 1 ? infos.first : infos
    end
    module_function :execute
  end
end
Stock = SorryYahooFinance
