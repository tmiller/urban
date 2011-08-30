require 'urban/version'
require 'open-uri'
require 'nokogiri'

module Urban
  class Dictionary

    URL = 'http://www.urbandictionary.com'

    attr_accessor :web_service

    def parse_definitions(document)
      definitions = document.xpath('//td/div[@class="definition"]').map do |node|
        node.xpath('//br').each { |br| br.replace(Nokogiri::XML::Text.new("\n", node.document)) };
        node.content.strip
      end
      definitions || []
    end

    def random
      document = Nokogiri::HTML(web_service.query(:random))
      word = document.at_css('.word').content.strip
      definitions = parse_definitions(document)
      { word: word, definitions: definitions }
    end

    def define(phrase)
      document = Nokogiri::HTML(web_service.query(:define, phrase))
      word = document.at_css('.word').content.strip
      definitions = parse_definitions(document)
      { word: word, definitions: definitions }
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

    def cweb_servicetalize(string, pattern)
      return string.gsub(pattern, &:upcase).gsub(/\s{2,}/, ' ')
    end

    def wordize(string)
      return cweb_servicetalize(string, /^\s*\w/)
    end

    def definitionize(string)
      return cweb_servicetalize(string, /^\s*\w|\.\s+\w/)
    end
  end
end
