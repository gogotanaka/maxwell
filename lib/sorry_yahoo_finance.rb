require "sorry_yahoo_finance/version"
require 'sorry_yahoo_finance/info'
require 'utils/all_stock_codes'
require 'utils/converter'
require 'utils/hash_accessor'
require 'utils/extended_hash'

module SorryYahooFinance
  class << self

    def GET(code_or_codes_or_sym, date_or_year=nil, month=nil, day=nil)
      date     = build_date(date_or_year, month, day)
      code_ary = build_code_ary(code_or_codes_or_sym)

      SorryYahooFinance::GET.execute(code_ary, date)
    end

    def build_code_ary(code_or_codes_or_sym)
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
    def execute(code_ary, date)
      infos = code_ary.map do |code|
        SorryYahooFinance::Info.new(code, date)
      end

      infos.count == 1 ? infos.first : infos
    end

    module_function :execute
  end

end
Stock = SorryYahooFinance