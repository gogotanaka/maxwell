class ::String
  def trim
    delete "\r\n\t"
  end
end

class ::Nokogiri::XML::Element
  def text_trim
    self.text.trim
  end
end
