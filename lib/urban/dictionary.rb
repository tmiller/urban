require 'urban/version'

require 'open-uri'
require 'nokogiri'

module Urban
  class Dictionary

    URL = 'http://www.urbandictionary.com'

    attr_accessor :api

    def random
      get_definition(query(:random))
    end

    def define(options)
      results = nil
      case
        when options.random
          results = api.query(:random)
        when options.phrase
          results = api.query(:define, options.phrase)
      end

    end

    def get_definition(document)
      word = wordize(node_to_s(document.at_css('.word')))
      definition = definitionize(node_to_s(document.at_xpath('//td/div[@class="definition"]')))
      return { word: word, definition: definition }
    end

    def query(type, word = nil)
      query = "#{type.to_s}.php"
      query << "?term=#{word}" if word
      doc = Nokogiri.HTML(open(URI.encode("#{URL}/#{query}")))
    end

    def node_to_s(node_set)
      node_set.children.each do |node|
        case node.name
        when 'br'
          node.previous.content = node.previous.content << "\n" if node.previous
          node.remove
        end
      end
      return node_set.content.strip.gsub(/\r/, "\n")
    end

    def capitalize(string, pattern)
      return string.gsub(pattern, &:upcase).gsub(/\s{2,}/, ' ')
    end

    def wordize(string)
      return capitalize(string, /^\s*\w/)
    end

    def definitionize(string)
      return capitalize(string, /^\s*\w|\.\s+\w/)
    end
  end
end
