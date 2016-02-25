require 'test_helper'

class InstagramScraper < Maxwell::Base
  attr_scrape :follower_count

  use_poltergeist true

  regist_strategy do
    @follower_count = @HTML.css("span._pr3wx").text
  end

  regist_handler do |result|
    binding.pry
  end
end

class InstagramTest < Minitest::Test
  InstagramScraper.new.execute "https://www.instagram.com/tokyo_meshistagram/"
end
