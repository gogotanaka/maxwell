module Maxwell
  class Helper
    def self.open_links(url, link_selectore, use_poltergeist=false)
      html = ::Maxwell::Converter.call(url, use_poltergeist)
      html.css(link_selectore).map { |a| a[:href] }
    end
  end
end
