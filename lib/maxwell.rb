require "maxwell/converter"
require 'csv'

class Maxwell
  def self.DO(config_hash, &block)
    url, next_config = config_hash.first
    html = Maxwell::Converter.execute url
    if next_config.is_a?(Proc)
      result = next_config.call(html)
      block.call(result)
    else
      target, next_config = next_config.first
      html.css(target).each do |a|
        self.DO({ a[:href] => next_config }, &block)
      end
    end
  end
end

class ::String
  def trim
    delete("\r\n\t")
  end
end
