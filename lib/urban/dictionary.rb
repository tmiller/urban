require 'urban/version'

require 'open-uri'
require 'nokogiri'

module Urban

  URL = 'http://www.urbandictionary.com/'

  def self.random
    doc = Nokogiri.HTML(open(URI.encode("#{URL}random.php")))
    word = clean_text(doc.at_css('.word')).gsub(/^\s*\w/) { |char| char.upcase }
    definition = paragraphize(doc.at_css('.definition'))
    return { word: word, definition: definition }
  end

  private
  def self.clean_text(node_set)
    node_set.children.each do |node|
      if node.name == 'br'
        node.remove
      else
        node.content = node.content.strip << ' '
      end
    end
    return node_set.content.strip.gsub(/ \./, '.')
  end

  def self.paragraphize(string)
    text = clean_text(string)
    return text.gsub(/\s{2,}/, ' ').gsub(/^\s*\w|\.\s+\w/) { |char| char.upcase }
  end
end
