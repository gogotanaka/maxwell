require "maxwell/converter"

class Maxwell
  @user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"

  class Base
    def self.attr_scrape(*attr_scrapes)
      @@attr_scrapes = attr_scrapes
    end

    def self.regist_strategy(link_selectore, &strategy_blk)
      @@link_selectore = link_selectore
      @@strategy_blk = strategy_blk
    end

    def self.regist_handler(&handler_blk)
      @@handler_blk = handler_blk
    end

    def execute(root_url)
      if @@link_selectore
        html = Maxwell::Converter.execute(root_url)
        html.css(@@link_selectore).each do |a|
          execute_for_result a[:href]
        end
      else
        execute_for_result root_url
      end
    end

    private def execute_for_result(tip_url)
      @html = Maxwell::Converter.execute(tip_url)
      self.instance_eval &@@strategy_blk

      result = @@attr_scrapes.map { |x| eval("@#{x}")  }
      @@handler_blk.call(result) if @@handler_blk
    end
  end
end

class ::String
  def trim
    delete("\r\n\t")
  end
end
