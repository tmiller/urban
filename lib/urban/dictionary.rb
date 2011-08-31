require 'nokogiri'
require 'ostruct'
require 'urban/version'
require 'urban/web'

module Urban
  class Dictionary

    def random
      document = Nokogiri::HTML(web_service.query(:random))
      process(document)
    end

    def define(phrase)
      document = Nokogiri::HTML(web_service.query(:define, phrase))
      process(document)
    end

  private

    def web_service
      @web_service ||= Urban::Web.new
    end

    def process(document)
      OpenStruct.new({
        word: document.at_xpath('//td[@class="word"][1]').content.strip,
        definitions: parse_definitions(document) })
    end

    def parse_definitions(document)
      definitions = document.xpath('//td/div[@class="definition"]').map do |node|
        node.xpath('//br').each { |br| br.replace(Nokogiri::XML::Text.new("\n", node.document)) };
        node.content.strip
      end
      definitions || []
    end

  end
end
