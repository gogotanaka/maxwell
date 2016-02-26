require 'nokogiri'
require 'httpclient'

require 'nokogiri'
require 'capybara'
require 'capybara/poltergeist'

module Maxwell
  class Converter
    @user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
    class << self
      def call(url, use_poltergeist=false)
        use_poltergeist ? call_with_js(url) : call_without_js(url)
      end

      def call_without_js(url)
        client = HTTPClient.new(
          default_header: {
            "User-Agent" => @user_agent
          }
        )

        html = begin
          client.get_content(url)
        rescue
          ""
        end

        Nokogiri::HTML(html)
      end

      def call_with_js(url)
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, { js_errors: false, timeout: 1000 })
        end
        Capybara.default_selector = :xpath
        session = Capybara::Session.new(:poltergeist)

        session.driver.headers = { 'User-Agent' => @user_agent }
        session.visit url
        Nokogiri::HTML(session.html).tap do
          session.driver.quit
        end
      end
    end
  end
end
