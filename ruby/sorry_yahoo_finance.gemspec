# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sorry_yahoo_finance/version'

Gem::Specification.new do |spec|
  spec.name          = "sorry_yahoo_finance"
  spec.version       = SorryYahooFinance::VERSION
  spec.authors       = ["gogotanaka"]
  spec.email         = ["mail@tanakakazuki.com"]
  spec.summary       = %q{Acquire stock infomations form yahoofinance, I am so sorry to Yahoo!.}
  spec.description   = %q{Acquire stock infomations form yahoofinance, I am so sorry to Yahoo!.}
  spec.homepage      = "http://gogotanaka.me/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
