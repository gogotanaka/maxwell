# Maxwell

Maxwell makes web scraping more simpler and faster with Ruby.

## Installation

```ruby
echo "gem 'maxwell'" >> Gemfile && bundle
```

Or install it yourself as:

    $ gem install maxwell

## Usage

```ruby
class YahooScraper < Maxwell::Base
  attr_accessor :title, :url, :address

  javascript true

  concurrency 4

  def parser html
    @title   = html.title
    @url     = html.css("td.sdhk jdj").text
    @address = html.css("table tr.ddad").text
  end

  def handler result
    p result
    #=> { title: "...", url: "...", address: "..." }
  end
end

YahooScraper.execute ["https://www.yahoo.com/"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec maxwell` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/maxwell. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
