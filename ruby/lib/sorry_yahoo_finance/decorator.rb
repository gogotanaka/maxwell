require 'json'

require "sorry_yahoo_finance/utils/decorate_cons"

unless Array.instance_methods(false).include?(:to_h)
  class Array
    def to_h
      Hash[self]
    end
  end
end

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
        stock_hash.map { |k, v| [JA_RABEL_HASH[k], v] }.to_h
      end

      def formalize_values(stock_hash)
        stock_hash.to_a.map { |key, value|
          return [key, nil] if value.nil?

          formated_value = case key
                           when *INT_KEYS
                            value.delete(",").to_i
                           when *FLOAT_KEYS
                            value.to_f
                           when :price_limit
                             value.delete!(",")
                             value =~ /(\d+)～(\d+)/
                             Range.new($1.to_i,$2.to_i)
                           when :prices
                             prices = stock_hash[:prices]
                             prices.select! {|price| price[:turnover] }
                             prices.map { |price| formalize_values(price) }
                           else
                             value
                           end
          [key, formated_value]
        }.to_h
      end

  end
end
