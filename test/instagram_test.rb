require 'test_helper'

class InstagramScraper < Maxwell::Base
  attr_accessor :follower_count

  javascript true

  def parser html
    @follower_count = html.css("span._pr3wx").text
  end

  def handler result
    $result = result
    $result[:follower_count] = $result[:follower_count].to_i
  end
end

class InstagramTest < Minitest::Test
  def test_main
    InstagramScraper.execute ["https://www.instagram.com/tokyo_meshistagram/"]

    assert $result[:follower_count] > 900
  end
end
