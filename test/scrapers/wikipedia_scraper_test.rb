require 'test_helper'

class WikipediaScraper < Maxwell::Base
  attr_accessor :title, :image_urls # attributes which you want to get

  # You need to define 2 methods
  # parser ... define how to parse attributes from html.
  # handler ... define what to do with result which is come from parser.

  def parser(html) # html is Nokogiri::HTML::Document object
    @title      = html.css('title').text # Ruby - Wikipedia
    @image_urls = html.css('img').map { |img| img[:src] } # ["//upload.wikimedia.org/wikipedia/commons/thumb/8/80/Ruby_-_Winza%2C_Tanzania.jpg/240px-Ruby_-_Winza%2C_Tanzania.jpg", ...]
  end

  def handler(result) # result is Hash which contain parsed attributes
    p result
    # output is
    # {
    #   :url => "https://en.wikipedia.org/wiki/Ruby",
    #   :title => "Ruby - Wikipedia",
    #   :image_urls => [
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/8/80/Ruby_-_Winza%2C_Tanzania.jpg/240px-Ruby_-_Winza%2C_Tanzania.jpg",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Corundum.png/220px-Corundum.png",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Ruby_transmittance.svg/220px-Ruby_transmittance.svg.png",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ruby_cristal.jpg/100px-Ruby_cristal.jpg",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Ruby_gem.JPG/160px-Ruby_gem.JPG",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Ruby_and_diamond_bracelet.jpg/160px-Ruby_and_diamond_bracelet.jpg",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Cut_Ruby.jpg/158px-Cut_Ruby.jpg",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/4/46/Artificial_ruby_hemisphere_under_a_normal_light.jpg/200px-Artificial_ruby_hemisphere_under_a_normal_light.jpg",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/3/38/Artificial_ruby_hemisphere_under_a_monochromatic_light.jpg/200px-Artificial_ruby_hemisphere_under_a_monochromatic_light.jpg",
    #     "//upload.wikimedia.org/wikipedia/commons/thumb/1/12/NMNH-Rubies-CroppedRotated.png/220px-NMNH-Rubies-CroppedRotated.png",
    #     "//upload.wikimedia.org/wikipedia/en/thumb/4/4a/Commons-logo.svg/30px-Commons-logo.svg.png",
    #     "//en.wikipedia.org/wiki/Special:CentralAutoLogin/start?type=1x1",
    #     "/static/images/wikimedia-button.png",
    #     "/static/images/poweredby_mediawiki_88x31.png"
    #   ]
    # }
  end
end

class WikipediaScraperTest < Minitest::Test
  WikipediaScraper.execute urls: %w[https://en.wikipedia.org/wiki/Ruby]

  def test_main
    array_of_result_hash = WikipediaScraper.execute urls: %w[https://en.wikipedia.org/wiki/Ruby]

    assert_kind_of Array, array_of_result_hash
    assert_equal 'https://en.wikipedia.org/wiki/Ruby', array_of_result_hash[0][:url]
    assert_equal 'Ruby - Wikipedia', array_of_result_hash[0][:title]
    refute_empty array_of_result_hash[0][:image_urls]
  end
end
