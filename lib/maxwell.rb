require 'parallel'

require "maxwell/converter"
require "maxwell/opener"

module Maxwell
  class Base
    class << self
      def attr_scrape(*attr_scrapes)
        @acquirer_class = Class.new do
          attr_accessor *attr_scrapes
          @attr_scrapes = attr_scrapes

          def self.attr_scrapes
            @attr_scrapes
          end

          def result
            self.class.attr_scrapes.map { |k| [k, send(k)]  }.to_h
          end
        end
      end

      def regist_strategy(&strategy_blk)
        @strategy_blk = strategy_blk
      end

      def regist_handler(&handler_blk)
        @handler_blk = handler_blk
      end

      def javascript(value)
        @use_poltergeist = value
      end

      def concurrency(value)
        @concurrency = value
      end
    end

    def initialize(urls)
      @urls = urls
    end

    def execute
      Parallel.
        map_with_index(@urls, in_threads: concurrency || 1) { |url, id| p "scraping: #{ id + 1 }"; get_result(url, id + 1)}.
        each do |result|
          self.handler_blk.call(result) if self.handler_blk
        end
    end

    def use_poltergeist
      self.class.instance_eval("@use_poltergeist")
    end

    def concurrency
      self.class.instance_eval("@concurrency")
    end

    def strategy_blk
      self.class.instance_eval("@strategy_blk")
    end

    def handler_blk
      self.class.instance_eval("@handler_blk")
    end

    def acquirer_class
      self.class.instance_eval("@acquirer_class")
    end

    private
      def get_result(url, id)
        acquirer = self.acquirer_class.new
        html = Maxwell::Converter.call(url, use_poltergeist)

        acquirer.instance_exec html, &self.strategy_blk

        { id: id }.merge(acquirer.result)
      end
  end
end

class ::String
  def trim
    delete("\r\n\t")
  end
end
