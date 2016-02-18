require "maxwell/converter"

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

          def initialize(nokogiri_obj)
            @html = nokogiri_obj
          end

          def result
            self.class.attr_scrapes.map { |k| [k, send(k)]  }.to_h
          end
        end
      end

      def regist_strategy(link_selectore=nil, &strategy_blk)
        @link_selectore = link_selectore
        @strategy_blk = strategy_blk
      end

      def regist_handler(&handler_blk)
        @handler_blk = handler_blk
      end
    end

    def execute(root_url)
      if self.link_selectore
        html = Maxwell::Converter.call(root_url)
        html.css(self.link_selectore).each do |a|
          execute_for_result a[:href]
        end
      else
        execute_for_result root_url
      end
    end

    def link_selectore
      self.class.instance_eval("@link_selectore")
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
      def execute_for_result(tip_url)
        acquirer = acquirer_class.new(Maxwell::Converter.call(tip_url))
        acquirer.instance_eval &self.strategy_blk

        acquirer.result.tap do |result|
          self.handler_blk.call(result) if self.handler_blk
        end
      end
  end
end

class ::String
  def trim
    delete("\r\n\t")
  end
end
