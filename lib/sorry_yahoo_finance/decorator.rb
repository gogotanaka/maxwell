require 'json'

require "sorry_yahoo_finance/utils/decorate_cons"

module SorryYahooFinance
  module Decorator
    include DecorateCons

    def output(lang, format)
      @stocks.map! { |stock_hash| formalize_values(stock_hash) }

      case lang
      when :ja
        @stocks.map! { |stock_hash| to_ja_key(stock_hash) }
      end

      case format
      when :hash
      when :json
        @stocks.map! &:to_json
      end

      @stocks
    end

    private
      def to_ja_key(stock_hash)
        Hash[
          stock_hash.to_a.map { |k, v| [JA_RABEL_HASH[k], v] }
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
                             elsif key == :prices
                               prices = stock_hash[:prices]
                               prices.select! {|price| price[:turnover] }
                               prices.map { |price| formalize_values(price) }
                             else
                               value
                             end
            [key, formated_value]
          end
        ]
      end

  end
end
