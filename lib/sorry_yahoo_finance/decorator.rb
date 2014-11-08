require "sorry_yahoo_finance/utils/decorate_cons"

module SorryYahooFinance
  module Decorator
    include DecorateCons
    attr_reader :stocks

    def output(lang, format)
      if format
        @stocks.map! do |stock_hash|
          formalize_values(stock_hash)
        end
      end

      if lang == :ja
        @stocks.map! do |stock_hash|
          to_ja_key(stock_hash)
        end
      end
      @stocks
    end

    private
      def to_ja_key(stock_hash)
        Hash[
          stock_hash.to_a.map { |ary| [JA_RABEL_HASH[ary[0]], ary[1]] }
        ]
      end

      def formalize_values(stock_hash)
        Hash[
          stock_hash.map do |key, value|
            formated_value = if value.nil?
                              nil
                             elsif INT_KEYS.include?(key)
                              value.delete(",").to_i
                             elsif FLOAT_KEYS.include?(key)
                              value.to_f
                             elsif key == :price_limit
                               value.delete!(",")
                               value =~ /(\d+)～(\d+)/
                               Range.new($1.to_i,$2.to_i)
                             else
                               value
                             end
            [key, formated_value]
          end
        ]
      end

  end
end
