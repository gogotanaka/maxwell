module Maxwell
  class Opener
    def self.call(url, link_selectore, use_poltergeist=false)
      html = ::Maxwell::Converter.call(url, use_poltergeist)
      html.css(link_selectore).map { |a| a[:href] }
    end
  end
end
