require 'urban/version'

require 'open-uri'
require 'nokogiri'

module Urban
  extend self

  URL = 'http://www.urbandictionary.com'

  def random
    get_definition(query(:random))
  end

  def define(word)
    get_definition(query(:define, word))
  end

  private
  def get_definition(document)
    word = wordize(document.at_css('.word'))
    definition = definitionize(document.at_css('.definition'))
    return { word: word, definition: definition }
  end

  def query(type, word = nil)
    query = "#{type.to_s}.php"
    query << "?term=#{word}" if word
    doc = Nokogiri.HTML(open(URI.encode("#{URL}/#{query}")))
  end

  def clean(node_set)
    node_set.children.each do |node|
      if node.name == 'br'
        node.remove
      else
        node.content = node.content.strip << ' '
      end
    end
    return node_set.content.strip.gsub(/ \./, '.')
  end

  def wordize(string)
    return clean(string).gsub(/^\s*\w/) { |char| char.upcase }
  end

  def definitionize(string)
    return clean(string).gsub(/\s{2,}/, ' ').gsub(/^\s*\w|\.\s+\w/) { |char| char.upcase }
  end
end
