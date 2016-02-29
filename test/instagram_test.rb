require 'test_helper'

class InstagramScraper < Maxwell::Base
  attr_scrape :follower_count

  javascript true

  regist_strategy do |html|
    @follower_count = html.css("span._pr3wx").text
  end

  regist_handler do |result|
    $result = result
    $result[:follower_count] = $result[:follower_count].to_i
  end
end

class InstagramTest < Minitest::Test
  def test_main
    scraper = InstagramScraper.new ["https://www.instagram.com/tokyo_meshistagram/"]
    scraper.execute

    assert $result[:follower_count] > 900
  end
end
