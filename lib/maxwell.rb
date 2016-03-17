require 'parallel'

require "maxwell/converter"
require "maxwell/helper"

require "maxwell/overide_ohter_class"

module Maxwell
  class NoParserDefinedErr; end

  class Base
    class << self
      def execute(urls)
        Parallel.
          map_with_index(urls, in_threads: @concurrency || 1) do |url, id|
            p "scraping: #{ id + 1 }"

            scraper = self.new
            html = Maxwell::Converter.call(url, @use_poltergeist)

            scraper.parser html

            scraper.handler ({ url: url }).merge(scraper.result)
          end
      end

      def attr_accessor(*attrs)
        @attrs ||= []
        @attrs.concat attrs
        super
      end

      def attrs
        @attrs || self.superclass.instance_eval("@attrs")
      end

      def javascript(value)
        @use_poltergeist = value
      end

      def concurrency(value)
        @concurrency = value
      end
    end

    def parser html
      raise NoParserDefinedErr "You need to define #{self}#parser"
    end

    def handler result
      p result
    end

    def result
      self.class.attrs.map { |k| [k, self.send(k)]  }.to_h
    end
  end
end
