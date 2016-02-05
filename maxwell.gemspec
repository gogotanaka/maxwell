# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maxwell/version'

Gem::Specification.new do |spec|
  spec.name          = "maxwell"
  spec.version       = Maxwell::VERSION
  spec.authors       = ["gogotanaka"]
  spec.email         = ["mail@tanakakazuki.com"]

  spec.summary       = %q{Maxwell makes web scraping more simpler and faster with Ruby.}
  spec.description   = %q{Maxwell makes web scraping more simpler and faster with Ruby.}
  spec.homepage      = "http://gogotanaka.me/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "httpclient"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
